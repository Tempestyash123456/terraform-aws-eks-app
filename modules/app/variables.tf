variable "app_image" {
  description = "Container image to deploy (e.g. nginx:latest or ECR URI)."
  type        = string
}

variable "app_container_port" {
  description = "Port the container listens on."
  type        = number
}

variable "app_replicas" {
  description = "Number of pod replicas."
  type        = number
  default     = 2
}

variable "app_service_type" {
  description = "Kubernetes service type (ClusterIP, NodePort, or LoadBalancer)."
  type        = string
  default     = "LoadBalancer"
}

variable "app_namespace" {
  description = "Kubernetes namespace to deploy the application into."
  type        = string
  default     = "default"
}

variable "cluster_name" {
  description = "Name of the EKS cluster (used for kubeconfig setup)."
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster API server endpoint."
  type        = string
}

variable "cluster_ca_cert" {
  description = "Base64-encoded certificate authority data for the EKS cluster."
  type        = string
}

variable "cluster_token" {
  description = "Authentication token for the EKS cluster."
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region of the EKS cluster."
  type        = string
}
