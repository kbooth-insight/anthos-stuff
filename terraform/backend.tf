terraform {
  backend "gcs" {
    bucket  = "booth-tf-state"
    prefix  = "terraform/anthos-stuff"
  }
}