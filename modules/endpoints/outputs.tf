output "vpc_endpoint_security_group_id" {
  description = "ID of the security group attached to all interface VPC endpoints."
  value       = aws_security_group.vpc_endpoints.id
}

output "ecr_api_endpoint_id" {
  description = "ID of the ECR API VPC endpoint."
  value       = aws_vpc_endpoint.ecr_api.id
}

output "ecr_dkr_endpoint_id" {
  description = "ID of the ECR DKR VPC endpoint."
  value       = aws_vpc_endpoint.ecr_dkr.id
}

output "s3_endpoint_id" {
  description = "ID of the S3 gateway VPC endpoint."
  value       = aws_vpc_endpoint.s3.id
}
