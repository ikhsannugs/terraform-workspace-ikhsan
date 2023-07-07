terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.72.1"
    }
  }
  backend "gcs" {
    bucket  = "terraform-ict-state"
    prefix  = "terraform/"
  }
}

provider "google" {
  project = "enhanced-cable-281809"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}
