output "eks_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority.0.data
}

output "eks_cluster_name" {
  value = aws_eks_cluster.this.id
}

output "alb_ingress_controller_iam_role_arn" {
  value = aws_iam_role.alb_ingress_controller_iam_role.arn
}

output "alb_ingress_external_dns_iam_role" {
  value = aws_iam_role.alb_ingress_external_dns_iam_role.arn
}

