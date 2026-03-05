output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_port" {
  value = module.rds.db_port
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}