resource "aws_security_group" "additional_cluster_sg" {
  name        = "${var.project}-${var.env}-${var.cluster_name}-additional-cluster-sg"
  description = "additional sg from which control plane can access workers"
  vpc_id      = var.vpc_id
  tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role" "cluster_role" {
  name               = "${var.project}-${var.env}-${var.cluster_name}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${var.project}-${var.env}-${var.cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_eks_cluster" "this" {
  name     = "${var.project}-${var.env}-${var.cluster_name}"
  role_arn = aws_iam_role.cluster_role.arn
  vpc_config {
    endpoint_public_access = true #default
    endpoint_private_access = false #default
    subnet_ids = compact([var.subnet_id_az1, var.subnet_id_az2, var.subnet_id_az3])
    security_group_ids = [ aws_security_group.additional_cluster_sg.id ]
    public_access_cidrs = [ "0.0.0.0/0" ]
  }
  enabled_cluster_log_types = [ 
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  version = "1.15"

  tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "terraform"
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.this
  ]
}