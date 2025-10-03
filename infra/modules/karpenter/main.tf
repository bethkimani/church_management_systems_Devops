# IAM Role for Karpenter Controller
resource "aws_iam_role" "karpenter_controller" {
  name = "${var.cluster_name}-karpenter-controller"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = var.cluster_oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${replace(var.cluster_oidc_provider_arn, "/^arn:aws:iam::\\d+:oidc-provider/oidc.eks\\./", "")}:aud" = "sts.amazonaws.com"
          "${replace(var.cluster_oidc_provider_arn, "/^arn:aws:iam::\\d+:oidc-provider/oidc.eks\\./", "")}:sub" = "system:serviceaccount:karpenter:karpenter"
        }
      }
    }]
  })
}

# Policies for Karpenter
resource "aws_iam_role_policy_attachment" "karpenter_controller_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])
  policy_arn = each.value
  role       = aws_iam_role.karpenter_controller.name
}

# Custom policy for EC2 provisioning
resource "aws_iam_policy" "karpenter_provisioner_policy" {
  name = "${var.cluster_name}-karpenter-provisioner-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:CreateTags",
          "ec2:TerminateInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:RunInstances",
          "ec2:DescribeLaunchTemplates",
          "ec2:DeleteLaunchTemplate",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeSpotPriceHistory"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [var.node_role_arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "karpenter_provisioner" {
  policy_arn = aws_iam_policy.karpenter_provisioner_policy.arn
  role       = aws_iam_role.karpenter_controller.name
}

# Helm Install (local-exec; depends handled at root)
resource "null_resource" "karpenter_helm" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.aws_region}
      helm repo add karpenter https://charts.karpenter.sh || true
      helm repo update
      kubectl create ns karpenter || true
      helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter \
        --namespace karpenter \
        --version 0.36.0 \
        --set serviceAccount.annotations."eks\\.amazonaws\\.com/role-arn"=${aws_iam_role.karpenter_controller.arn} \
        --set clusterName=${var.cluster_name} \
        --set clusterEndpoint=${var.cluster_endpoint}
    EOT
  }

  # Triggers on changes
  triggers = {
    cluster_name = var.cluster_name
  }
}

# Instance Profile
resource "aws_iam_instance_profile" "karpenter_nodes" {
  name = "KarpenterNodeInstanceProfile-${var.cluster_name}"
  role = var.node_role_name
}