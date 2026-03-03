module "eks_app" {
  source = "../../"

  # Required
  cluster_name       = "my-eks-cluster"
  aws_region         = "us-east-1"
  app_image          = "nginx:latest"
  app_container_port = 80

  # Optional - networking
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.3.0/24", "10.0.4.0/24"]

  # Optional - cluster sizing
  min_size     = 2
  max_size     = 3
  desired_size = 2

  # Optional - application
  app_replicas     = 2
  app_service_type = "LoadBalancer"
  app_namespace    = "production"
  env              = "prod"
}
