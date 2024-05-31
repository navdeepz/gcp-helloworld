variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region of the GCP project"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "webapp-cluster"
}

variable "initial_node_count" {
  description = "Initial number of nodes in the GKE cluster"
  default     = 1
}

variable "max_node_count" {
  description = "Max number of nodes in the GKE cluster"
  default     = 1
}

variable "machine_type" {
  description = "Machine type for the GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "gke_disk_size_gb" {
  description = "Worker node disk size"
  default     = 50
}

variable "oauth_scopes" {
  description = "List of OAuth scopes to be assigned to the cluster"
  type        = list(string)
  default     = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

variable "redis_memory_size_gb" {
  description = "Worker node disk size"
  default     = 1
}