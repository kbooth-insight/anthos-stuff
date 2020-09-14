set -ex

# asmctl says to export these
export PROJECT_ID="booth-playground"
export PROJECT_NUMBER=$(gcloud projects describe booth-playground --format="value(parent.id)")
export ENVIRONMENT_PROJECT_NUMBER=$PROJECT_NUMBER
export PROJECT_LOCATION="us-central1-c"
export CLUSTER_NAME="booth-asm-test"
export IDNS="${PROJECT_ID}.svc.id.goog"


# should append OS here
ANTHOS_ASM_VERSION="1.6.8-asm.9"
ANTHOS_ASM_PACKAGE_NAME="istio-${ANTHOS_ASM_VERSION}"


gcloud services enable \
    --project=${PROJECT_ID} \
    container.googleapis.com \
    compute.googleapis.com \
    monitoring.googleapis.com \
    logging.googleapis.com \
    cloudtrace.googleapis.com \
    meshca.googleapis.com \
    meshtelemetry.googleapis.com \
    meshconfig.googleapis.com \
    iamcredentials.googleapis.com \
    gkeconnect.googleapis.com \
    gkehub.googleapis.com \
    cloudresourcemanager.googleapis.com

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user="$(gcloud config get-value core/account)"

curl -LO https://storage.googleapis.com/gke-release/asm/${ANTHOS_ASM_PACKAGE_NAME}-osx.tar.gz
curl -LO https://storage.googleapis.com/gke-release/asm/${ANTHOS_ASM_PACKAGE_NAME}-osx.tar.gz.1.sig

tar xzfv ${ANTHOS_ASM_PACKAGE_NAME}-osx.tar.gz
cd $ANTHOS_ASM_PACKAGE_NAME


kpt pkg get https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages.git/asm@release-1.6-asm asm
kpt cfg set asm gcloud.core.project ${PROJECT_ID}
kpt cfg set asm gcloud.project.environProjectNumber ${PROJECT_NUMBER}
kpt cfg set asm gcloud.container.cluster ${CLUSTER_NAME}
kpt cfg set asm gcloud.compute.location ${CLUSTER_LOCATION}
kpt cfg set asm anthos.servicemesh.profile asm-gcp


./bin/istioctl install -f asm/cluster/istio-operator.yaml  
kubectl apply -f asm/canonical-service/controller.yaml
