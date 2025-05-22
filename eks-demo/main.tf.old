module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "example"
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = false

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = "vpc-0afb97da3e39bd790"
  subnet_ids = ["subnet-0ca4711696dff18e0", "subnet-08081ec18faebf7ac", "subnet-00540c9cac18e133f"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
