provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  cluster_name = var.cluster_name
  vpc_cidr = var.vpc_cidr
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  cluster_name = var.cluster_name
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  db_username = var.db_username
  db_password = var.db_password
  cluster_name = var.cluster_name
  eks_sg_id = module.eks.eks_cluster_sg_id
}

module "karpenter" {
  source = "./modules/karpenter"
  cluster_name = var.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_oidc_provider_arn = module.eks.oidc_provider_arn
  node_role_arn = module.eks.node_role_arn
  node_role_name = module.eks.node_role_name
  aws_region = var.aws_region
  depends_on = [module.eks]
}