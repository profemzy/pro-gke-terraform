terraform {

  backend "gcs" {
    bucket  = "artifacts.invl-cowries.appspot.com"
    prefix  = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.71.0"
    }
  }
}

