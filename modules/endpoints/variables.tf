variable "cluster_name" {
  description = "EKS cluster name, used to name VPC endpoint resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to create endpoints in."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC, used in security group ingress rules."
  type        = string
}

variable "aws_region" {
  description = "AWS region, used to construct endpoint service names."
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for interface-type endpoints."
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "List of private route table IDs for the S3 gateway endpoint."
  type        = list(string)
}

variable "env" {
  description = "Environment name applied as a tag."
  type        = string
  default     = "dev"
}
