resource "google_compute_network" "vpc_network" {
  name                    = "webapp-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "my-subnetwork"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/16"
  }
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "google-managed-services-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  network  = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.subnetwork.name

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count
  node_config {
    machine_type = var.machine_type
    oauth_scopes = var.oauth_scopes
    disk_size_gb = var.gke_disk_size_gb
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.initial_node_count

  node_config {
    machine_type = var.machine_type

    oauth_scopes = var.oauth_scopes
    disk_size_gb = var.gke_disk_size_gb

    labels = {
      "env" = "dev"
    }

    tags = ["gke-node"]
  }

  autoscaling {
    min_node_count = var.initial_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
  
}
data "google_client_config" "default" {}


resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_sql_database_instance" "postgres_instance" {
  name             = "postgres-instance"
  database_version = "POSTGRES_14"
  region           = var.region
  # deletion_protection = true

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
      # ipv4_enabled    = true
      # require_ssl     = true
    }
  }
}

resource "google_sql_database" "database" {
  name     = "webapp_db"
  instance = google_sql_database_instance.postgres_instance.name
}
resource "random_password" "postgres_password" {
  length = 16
  special = true
}

resource "google_sql_user" "users" {
  name     = "webapp_user"
  instance = google_sql_database_instance.postgres_instance.name
  password = random_password.postgres_password.result
}


resource "google_redis_instance" "redis_instance" {
  name           = "redis-instance"
  tier           = "STANDARD_HA"
  memory_size_gb = var.redis_memory_size_gb
  region         = var.region
  authorized_network = google_compute_network.vpc_network.id

  redis_configs = {
    maxmemory-policy = "allkeys-lru"
  }
}


resource "google_compute_firewall" "default" {
  name    = "allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/24"]
}



# Save state in GCS 
terraform {
  backend "gcs" {
    bucket = "nav-test-terraform-state-bucket"
    prefix = "terraform/state"
  }
}