variable project_id {}
variable prefix {}
variable region {}
variable zones {}
variable vpc {}
variable subnet {}
variable pod_cidr_range {}
variable services_cidr_range {}
variable "acm_sync_repo" {
  description = "Anthos config management Git repo"
  type        = string
  default     = "git@github.com:GoogleCloudPlatform/csp-config-management.git"
}

variable "acm_sync_branch" {
  description = "Anthos config management Git branch"
  type        = string
  default     = "1.0.0"
}

variable "acm_policy_dir" {
  description = "Subfolder containing configs in ACM Git repo"
  type        = string
  default     = "foo-corp"
}

variable "operator_path" {
  description = "Path to the operator yaml config. If unset, will download from GCS releases."
  type        = string
  default     = null
}