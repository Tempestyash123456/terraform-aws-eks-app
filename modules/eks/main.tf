module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name               = var.cluster_name
  kubernetes_version = "1.35"

  endpoint_public_access                   = true
  endpoint_private_access                  = true
  enable_cluster_creator_admin_permissions = true
  create_auto_mode_iam_resources           = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  authentication_mode = "API_AND_CONFIG_MAP"

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    node-group-by-tf = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["c7i-flex.large"]

      subnet_ids = var.subnet_ids

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
    }
  }

  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}

resource "time_sleep" "wait_for_eks" {
  depends_on      = [module.eks]
  create_duration = "300s"
}

resource "aws_ec2_tag" "cluster_sg_tag" {
  resource_id = module.eks.cluster_primary_security_group_id
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "owned"
  depends_on  = [time_sleep.wait_for_eks]
}

data "aws_eks_cluster" "main" {
  name       = module.eks.cluster_name
  depends_on = [time_sleep.wait_for_eks]
}

data "aws_eks_cluster_auth" "main" {
  name       = module.eks.cluster_name
  depends_on = [time_sleep.wait_for_eks]
}
