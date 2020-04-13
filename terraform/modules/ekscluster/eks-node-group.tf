resource "aws_iam_role" "node_role" {
  name               = "${var.project}-${var.env}-${var.cluster_name}-eks-node-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
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

resource "aws_iam_policy" "cluster_autoscaler_iam_policy" {
  name        = "${var.project}-${var.env}-${var.cluster_name}-EKSClusterAutoScalerPolicy"
  path        = "/"
  description = "policy to allow worker node to scale"

  #policy got from https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-autoscaler-setup/
  policy = file("${path.module}/resources/cluster-autoscaler-iam-policy.json")
}

resource "aws_iam_policy" "ebs_cni_iam_policy" {
  name        = "${var.project}-${var.env}-${var.cluster_name}-EKSEbsCniIamPolicy"
  path        = "/"
  description = "policy to allow worker node to create volumes"

  #policy got from https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v0.4.0/docs/example-iam-policy.json
  policy = file("${path.module}/resources/ebs-cni-iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "ebs_cni_iam_policy_attachment" {
  policy_arn = aws_iam_policy.ebs_cni_iam_policy.arn
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_iam_policy_attachment" {
  policy_arn = aws_iam_policy.cluster_autoscaler_iam_policy.arn
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_security_group" "ssh_access_to_workers_sg" {
  name        = "${var.project}-${var.env}-${var.cluster_name}-ssh-access-to-workers-source-sg"
  description = "attach this security group to an instance to access eks worker via ssh"
  vpc_id      = var.vpc_id
  tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

resource "aws_eks_node_group" "node_group_az1" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project}-${var.env}-${var.cluster_name}-eks-nodegroup-az1"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = [ var.subnet_id_az1 ]
  disk_size       = var.node_disk_size
  instance_types  = [ var.instance_type ]
  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
    source_security_group_ids = [ aws_security_group.ssh_access_to_workers_sg.id ] #attach this sg to an instance to access worker via ssh
  }
  scaling_config {
    desired_size = var.sg_desired_size
    min_size     = var.sg_min_size
    max_size     = var.asg_max_size
  }
  tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "terraform"
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "node_group_az2" {
  count           = var.want_workers_in_az2 ? 1 : 0 
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project}-${var.env}-${var.cluster_name}-eks-nodegroup-az2"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = [ var.subnet_id_az2 ]
  disk_size       = var.node_disk_size
  instance_types  = [ var.instance_type ]
  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
    source_security_group_ids = [ aws_security_group.ssh_access_to_workers_sg.id ] #attach this sg to an instance to access worker via ssh
  }
  scaling_config {
    desired_size = var.sg_desired_size
    min_size     = var.sg_min_size
    max_size     = var.asg_max_size
  }
  tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "terraform"
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "node_group_az3" {
  count           = var.want_workers_in_az3 ? 1 : 0 
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project}-${var.env}-${var.cluster_name}-eks-nodegroup-az3"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = [ var.subnet_id_az3 ]
  disk_size       = var.node_disk_size
  instance_types  = [ var.instance_type ]
  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
    source_security_group_ids = [ aws_security_group.ssh_access_to_workers_sg.id ] #attach this sg to an instance to access worker via ssh
  }
  scaling_config {
    desired_size = var.sg_desired_size
    min_size     = var.sg_min_size
    max_size     = var.asg_max_size
  }
  tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "terraform"
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}