# terraform-aws-eks-app

A Terraform module that provisions a production-ready Amazon EKS cluster with VPC networking, VPC endpoints, and deploys a containerised application onto the cluster.


## Features

- **VPC** with public and private subnets, single NAT gateway, and correct Kubernetes subnet tags
- **EKS** cluster (Kubernetes 1.35) with EKS Auto Mode, managed node group, and all essential add-ons (`coredns`, `kube-proxy`, `vpc-cni`, `eks-pod-identity-agent`)
- **VPC Endpoints** for ECR API, ECR DKR, S3, CloudWatch Logs, and STS — keeping traffic off the public internet
- **Kubernetes Deployment** with rolling update strategy, liveness/readiness probes, and resource requests
- **Kubernetes Service** with AWS NLB annotations for internet-facing load balancing

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with credentials that have permissions to create EKS, VPC, IAM, and EC2 resources

## Usage

```hcl
module "eks_app" {
  source  = "Tempestyash123456/eks-app/aws"
  version = "~> 1.0"

  cluster_name       = "my-cluster"
  aws_region         = "us-east-1"
  app_image          = "nginx:latest"
  app_container_port = 80
}
```

### With all options

```hcl
module "eks_app" {
  source  = "Tempestyash123456/eks-app/aws"
  version = "~> 1.0"

  # Required
  cluster_name       = "my-cluster"
  aws_region         = "us-east-1"
  app_image          = "nginx:latest"
  app_container_port = 80

  # Networking
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.3.0/24", "10.0.4.0/24"]

  # Node group scaling
  min_size     = 2
  max_size     = 5
  desired_size = 2

  # Application
  app_replicas     = 3
  app_service_type = "LoadBalancer"
  app_namespace    = "production"
  env              = "prod"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `aws_region` | AWS region for all resources | `string` | `"us-east-1"` | no |
| `cluster_name` | EKS cluster name | `string` | n/a | **yes** |
| `app_image` | Container image URI | `string` | n/a | **yes** |
| `app_container_port` | Port the container listens on | `number` | n/a | **yes** |
| `app_replicas` | Number of pod replicas (1–10) | `number` | `2` | no |
| `app_service_type` | Kubernetes service type | `string` | `"LoadBalancer"` | no |
| `app_namespace` | Kubernetes namespace | `string` | `"default"` | no |
| `vpc_cidr` | VPC CIDR block | `string` | `"10.0.0.0/16"` | no |
| `availability_zones` | Availability zones | `list(string)` | `["us-east-1a", "us-east-1b"]` | no |
| `private_subnets` | Private subnet CIDRs | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]` | no |
| `public_subnets` | Public subnet CIDRs | `list(string)` | `["10.0.3.0/24", "10.0.4.0/24"]` | no |
| `env` | Environment name (used as tag) | `string` | `"dev"` | no |
| `min_size` | Minimum node count | `number` | `2` | no |
| `max_size` | Maximum node count | `number` | `3` | no |
| `desired_size` | Desired node count | `number` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_name` | Name of the EKS cluster |
| `cluster_endpoint` | API server endpoint of the EKS cluster |
| `vpc_id` | ID of the created VPC |
| `private_subnets` | List of private subnet IDs |
| `service_name` | Name of the Kubernetes service |
| `service_type` | Type of the Kubernetes service |
| `load_balancer_hostname` | NLB hostname (when service type is LoadBalancer) |
| `check_service_command` | kubectl command to inspect the service |
| `port_forward_command` | kubectl command for local port-forwarding |

