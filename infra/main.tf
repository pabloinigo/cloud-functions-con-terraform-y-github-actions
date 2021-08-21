terraform {
  backend "gcs" {
    bucket = "function_github"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "mkdevyoutube"
  region  = "europe-west1"
}
