# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.16.0/20"

  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cluster_secondary_range_cidr
  }

  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.services_secondary_range_cidr
  }

  private_ip_google_access = true

  depends_on = [
    google_compute_network.vpc,
  ]
}
