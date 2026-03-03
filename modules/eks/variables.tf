variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be created."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster and node groups."
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region where the cluster is deployed."
  type        = string
}

variable "env" {
  description = "Environment name applied as a tag."
  type        = string
  default     = "dev"
}

variable "min_size" {
  description = "Minimum number of nodes in the managed node group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes in the managed node group."
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired number of nodes in the managed node group."
  type        = number
  default     = 2
}
