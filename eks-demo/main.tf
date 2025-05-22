module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.3"

  cluster_name    = "example"
  cluster_version = "1.31"
  vpc_id     = "vpc-0afb97da3e39bd790"
  subnet_ids = ["subnet-0ca4711696dff18e0", "subnet-08081ec18faebf7ac", "subnet-00540c9cac18e133f"]

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1
    }
  }


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
