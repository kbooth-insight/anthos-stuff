
locals {
    # prefix
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version = "11.1.0"
  project_id                 = var.project_id
  name                       = "${var.prefix}-gke"
  region                     = var.region
  zones                      = var.zones
  network                    = var.vpc
  subnetwork                 = var.subnet
  ip_range_pods              = "us-central1-01-gke-01-pods"
  ip_range_services          = "us-central1-01-gke-01-services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true

  node_pools = [
    {
      name               = "${var.prefix}-node-pool"
      machine_type       = "e2-medium"
      min_count          = 1
      max_count          = 2
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = "project-service-account@${var.project_id}.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 80
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}