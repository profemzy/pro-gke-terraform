# Cluster
variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "cluster_secondary_range_cidr" {
  type = string
}

variable "services_secondary_range_name" {
  type = string

  description = <<EOF
    The name of the secondary range to be used as for the services CIDR block.
    The secondary range will be used for service ClusterIPs. This must be an
    existing secondary range associated with the cluster subnetwork.
    EOF
}

variable "services_secondary_range_cidr" {
  type = string
}

variable "cluster_secondary_range_name" {
  type = string

  description = <<EOF
  The name of the secondary range to be used as for the cluster CIDR block.
  The secondary range will be used for pod IP addresses. This must be an
  existing secondary range associated with the cluster subnetwork.
  EOF
}

variable "master_ipv4_cidr_block" {
  type = string
  default = "172.16.0.0/28"
}

# VPC
variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

