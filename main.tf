module "vpc" {
  source = "./modules/vpc"

  cluster_name       = var.cluster_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  env                = var.env
}

module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  aws_region   = var.aws_region
  env          = var.env
  min_size     = var.min_size
  max_size     = var.max_size
  desired_size = var.desired_size
}

module "endpoints" {
  source = "./modules/endpoints"

  cluster_name            = var.cluster_name
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = var.vpc_cidr
  aws_region              = var.aws_region
  private_subnets         = module.vpc.private_subnets
  private_route_table_ids = module.vpc.private_route_table_ids
  env                     = var.env
}

module "app" {
  source = "./modules/app"

  app_image          = var.app_image
  app_container_port = var.app_container_port
  app_replicas       = var.app_replicas
  app_service_type   = var.app_service_type
  app_namespace      = var.app_namespace

  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca_cert  = module.eks.cluster_ca_cert
  cluster_token    = module.eks.cluster_token
  aws_region       = var.aws_region
}
