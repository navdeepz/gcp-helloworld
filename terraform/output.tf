output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}
output "postgres_host" {
  value = google_sql_database_instance.postgres_instance.private_ip_address
}

output "redis_host" {
  value = google_redis_instance.redis_instance.host
}

output "db_user" {
  value = google_sql_user.users.name
}

output "db_password" {
  sensitive = true
  value = random_password.postgres_password.result
}

output "db_name" {
  value = google_sql_database.database.name
}