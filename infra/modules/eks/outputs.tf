output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_id" {
  value = aws_eks_cluster.main.id
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster.id
}

output "node_role_arn" {
  value = aws_iam_role.eks_node.arn
}

output "node_role_name" {
  value = aws_iam_role.eks_node.name
}