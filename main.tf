terraform {

  backend "gcs" {
    bucket  = "artifacts.invl-cowries.appspot.com"
    prefix  = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }

  required_version = "~> 0.14"
}

