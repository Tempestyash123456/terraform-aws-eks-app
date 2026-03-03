variable "aws_region" {
  description = "AWS region where all resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix for related resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to deploy resources into."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets (one per availability zone)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets (one per availability zone)."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "env" {
  description = "Environment name (e.g. dev, staging, prod). Applied as a tag to all resources."
  type        = string
  default     = "dev"
}

variable "min_size" {
  description = "Minimum number of worker nodes in the EKS managed node group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes in the EKS managed node group."
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired number of worker nodes in the EKS managed node group."
  type        = number
  default     = 2
}

variable "app_image" {
  description = "Container image to deploy (e.g. nginx:latest or 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:v1)."
  type        = string
}

variable "app_container_port" {
  description = "Port the container listens on."
  type        = number
}

variable "app_replicas" {
  description = "Number of pod replicas for the application deployment."
  type        = number
  default     = 2
  validation {
    condition     = var.app_replicas >= 1 && var.app_replicas <= 10
    error_message = "app_replicas must be between 1 and 10."
  }
}

variable "app_service_type" {
  description = "Kubernetes service type for the application (ClusterIP, NodePort, or LoadBalancer)."
  type        = string
  default     = "LoadBalancer"
  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer"], var.app_service_type)
    error_message = "app_service_type must be one of: ClusterIP, NodePort, LoadBalancer."
  }
}

variable "app_namespace" {
  description = "Kubernetes namespace to deploy the application into."
  type        = string
  default     = "default"
}
