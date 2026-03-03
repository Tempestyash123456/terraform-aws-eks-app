output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "API server endpoint of the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "vpc_id" {
  description = "ID of the VPC created for the cluster."
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of private subnet IDs."
  value       = module.vpc.private_subnets
}

output "service_name" {
  description = "Name of the Kubernetes service created for the application."
  value       = module.app.service_name
}

output "service_type" {
  description = "Type of the Kubernetes service (ClusterIP, NodePort, or LoadBalancer)."
  value       = module.app.service_type
}

output "load_balancer_hostname" {
  description = "Hostname of the Network Load Balancer. Available only when app_service_type is LoadBalancer."
  value       = module.app.load_balancer_hostname
}

output "check_service_command" {
  description = "kubectl command to inspect the application service."
  value       = module.app.check_service_command
}

output "port_forward_command" {
  description = "kubectl command to access the application via port-forwarding."
  value       = module.app.port_forward_command
}
