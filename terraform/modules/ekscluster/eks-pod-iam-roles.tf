### role for ingress controller

resource "aws_iam_policy" "alb_ingress_controller_iam_policy" {
  name        = "${var.project}-${var.env}-${var.cluster_name}-EKSalbIngressControllerIamPolicy"
  path        = "/"
  description = "policy to allow ingress controller of eks to create alb"

  #policy got from https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json
  policy = file("${path.module}/resources/ingress-iam-policy.json")
}

resource "aws_iam_role" "alb_ingress_controller_iam_role" {
  name               = "${var.project}-${var.env}-${var.cluster_name}-EKSalbIngressControllerIamRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRoleWithWebIdentity"
      Effect    = "Allow"
      Principal = {
        Federated = "${aws_iam_openid_connect_provider.this.arn}"
      }
    }]
  })

  tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "alb_ingress_controller_policy_attachment" {
  policy_arn = aws_iam_policy.alb_ingress_controller_iam_policy.arn
  role       = aws_iam_role.alb_ingress_controller_iam_role.name
}

### for cration of dns records by ingress companion

resource "aws_iam_policy" "alb_ingress_external_dns_iam_policy" {
  name        = "${var.project}-${var.env}-${var.cluster_name}-EKSalbIngressExternalDNSIamPolicy"
  path        = "/"
  description = "policy to allow ingress controller of eks to create alb"

  #policy got from https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md#iam-permissions
  policy = file("${path.module}/resources/ingress-external-dns-iam-policy.json")
}

resource "aws_iam_role" "alb_ingress_external_dns_iam_role" {
  name               = "${var.project}-${var.env}-${var.cluster_name}-EKSalbIngressExternalDNSIamRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRoleWithWebIdentity"
      Effect    = "Allow"
      Principal = {
        Federated = "${aws_iam_openid_connect_provider.this.arn}"
      }
    }]
  })

  tags = {
    Environment = var.env
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "alb_ingress_external_dns_policy_attachment" {
  policy_arn = aws_iam_policy.alb_ingress_external_dns_iam_policy.arn
  role       = aws_iam_role.alb_ingress_external_dns_iam_role.name
}
