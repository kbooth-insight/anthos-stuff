
data "google_client_config" "default" {
}


data google_project this {
  project_id = var.project_id

}

resource random_pet sa_suffix {

}

module "gke" {
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster/"
  project_id              = var.project_id
  name                    = "${var.prefix}-gke"
  regional                = false
  region                  = var.region
  zones                   = var.zones
  release_channel         = "REGULAR"
  network                 = var.vpc
  subnetwork              = var.subnet
  ip_range_pods           = var.pod_cidr_range
  ip_range_services       = var.services_cidr_range
  network_policy          = false
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.this.number}" }
  node_pools = [
    {
      name         = "default-node-pool"
      autoscaling  = false
      auto_upgrade = true
      # ASM requires minimum 4 nodes and e2-standard-4
      node_count   = 2
      machine_type = "e2-standard-4"
    },
  ]
}

module "asm" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/asm"
  cluster_name     = module.gke.name
  cluster_endpoint = module.gke.endpoint
  project_id       = var.project_id
  location         = module.gke.location
  gke_hub_sa_name  = "${var.prefix}-sa"
}

module "acm" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/acm"
  project_id       = var.project_id
  location         = module.gke.location
  cluster_name     = module.gke.name
  sync_repo        = var.acm_sync_repo
  sync_branch      = var.acm_sync_branch
  policy_dir       = var.acm_policy_dir
  cluster_endpoint = module.gke.endpoint
  operator_path    = var.operator_path
}