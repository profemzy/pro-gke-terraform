# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }


  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "212.59.65.187/32"
      display_name = "Perimeter81"
    }
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  # I only want 2 nodes for demo one in each zone
  node_locations = ["europe-west3-a", "europe-west3-c"]

  autoscaling {
    max_node_count = 2
    min_node_count = 1
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    preemptible  = true # not for production or sustained usage
    machine_type = "e2-medium"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}


# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only. 
# # It references the variables and resources provisioned in this file. 
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }

