

ANTHOS_ASM_VERSION="1.6.8-asm.9"
ANTHOS_ASM_PACKAGE_NAME="istio-${ANTHOS_ASM_VERSION}"

curl -LO https://storage.googleapis.com/gke-release/asm/${ANTHOS_ASM_PACKAGE_NAME}-osx.tar.gz
curl -LO https://storage.googleapis.com/gke-release/asm/${ANTHOS_ASM_PACKAGE_NAME}-osx.tar.gz.1.sig

tar xzfv istio-1.6.8-asm.9-osx.tar.gz
cd $ANTHOS_ASM_PACKAGE_NAME


kpt pkg get https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages.git/asm@release-1.6-asm asm
kpt cfg set asm gcloud.core.project ${PROJECT_ID}
kpt cfg set asm gcloud.project.environProjectNumber ${ENVIRON_PROJECT_NUMBER}
kpt cfg set asm gcloud.container.cluster ${CLUSTER_NAME}
kpt cfg set asm gcloud.compute.location ${CLUSTER_LOCATION}
kpt cfg set asm anthos.servicemesh.profile asm-gcp
./bin/istioctl install -f asm/cluster/istio-operator.yaml  
kubectl apply -f asm/canonical-service/controller.yaml
