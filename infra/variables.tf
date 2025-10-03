variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "church-eks-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  default     = "church_user"
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  default     = "churchpass123!"  # CHANGE THIS in prod; use secrets
  sensitive   = true
}