output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "API server endpoint of the EKS cluster."
  value       = data.aws_eks_cluster.main.endpoint
}

output "cluster_ca_cert" {
  description = "Base64-encoded certificate authority data for the cluster."
  value       = data.aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_token" {
  description = "Authentication token for the EKS cluster."
  value       = data.aws_eks_cluster_auth.main.token
  sensitive   = true
}

output "cluster_primary_security_group_id" {
  description = "ID of the EKS cluster primary security group."
  value       = module.eks.cluster_primary_security_group_id
}
