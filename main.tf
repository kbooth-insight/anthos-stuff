
locals {
  # prefix
}

data google_project this {
  project_id = var.project_id

}

module "gke" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster/"
  project_id        = var.project_id
  name              = "${var.prefix}-gke"
  regional          = false
  region            = var.region
  zones             = var.zones
  network           = var.vpc
  subnetwork        = var.subnet
  ip_range_pods     = var.pod_cidr_range
  ip_range_services = var.service_cidr_range
  service_account   = "create"
  remove_default_node_pool = true
  initial_node_count = 2
}

data "google_client_config" "default" {
}

