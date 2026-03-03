output "service_name" {
  description = "Name of the Kubernetes service."
  value       = kubernetes_service_v1.app.metadata[0].name
}

output "service_type" {
  description = "Type of the Kubernetes service."
  value       = kubernetes_service_v1.app.spec[0].type
}

output "service_cluster_ip" {
  description = "Cluster IP of the service."
  value       = try(kubernetes_service_v1.app.spec[0].cluster_ip, "unknown")
}

output "load_balancer_hostname" {
  description = "Load balancer hostname, if provisioned."
  value       = try(kubernetes_service_v1.app.status[0].load_balancer[0].ingress[0].hostname, "pending")
}

output "check_service_command" {
  description = "kubectl command to check service status."
  value       = "kubectl get svc ${kubernetes_service_v1.app.metadata[0].name} -n ${kubernetes_service_v1.app.metadata[0].namespace}"
}

output "port_forward_command" {
  description = "kubectl command to access the app via port-forwarding."
  value       = "kubectl port-forward deployment/${local.safe_deploy_name} 8080:${var.app_container_port}"
}
