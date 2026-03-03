output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks_app.cluster_name
}

output "load_balancer_hostname" {
  description = "Hostname of the application load balancer."
  value       = module.eks_app.load_balancer_hostname
}
