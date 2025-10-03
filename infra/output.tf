output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_kubeconfig_command" {
  description = "kubectl command to connect to cluster"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_id} --region ${var.aws_region}"
}

output "rds_endpoint" {
  description = "Endpoint for RDS Postgres instance"
  value       = module.rds.db_endpoint
}