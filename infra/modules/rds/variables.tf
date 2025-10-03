variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "cluster_name" {
  type = string
}

variable "eks_sg_id" {
  type    = string
  default = ""  # Optional; use if passing EKS SG
}