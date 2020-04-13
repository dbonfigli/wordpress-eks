resource "aws_efs_file_system" "this" {
  tags = {
    Name        = "wpsite-development-efs"
    Environment = "development"
    Project     = "wpsite"
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "wpsite-development-efs-sg"
  description = "used by eks"
  vpc_id      = "vpc-00000000"
  ingress {
    description = "access to efs"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = "development"
    Project     = "wpsite"
    ManagedBy   = "terraform"
  }
}

resource "aws_efs_mount_target" "az1" {
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = "subnet-0000000000000000"
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "az2" {
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = "subnet-0000000000000000"
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_ecr_repository" "wordpress" {
  name = "mywordpress"
  tags = {
    Environment = "development"
    Project     = "wpsite"
    ManagedBy   = "terraform"
  }
}

module "ekscluster" {
  source              = "../../modules/ekscluster"
  env                 = "development"
  project             = "wpsite"
  cluster_name        = "wpsite"
  vpc_id              = "vpc-00000000"
  subnet_id_az1       = "subnet-0000000000000000"
  subnet_id_az2       = "subnet-0000000000000000"
  ec2_ssh_key         = "ssh-key"
  want_workers_in_az2 = true
  instance_type       = "t3.large"
}