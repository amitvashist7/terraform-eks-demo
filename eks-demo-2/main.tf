# Create an EKS cluster
resource "aws_eks_cluster" "example" {
  name     = "my-eks-cluster-2"
  role_arn = aws_iam_role.example.arn
  version  = "1.31"

  vpc_config {
    #subnet_ids = ["subnet-0dd44d0c0b546abb4", "subnet-0e435d75327b592c3"]
    subnet_ids = ["subnet-0ca4711696dff18e0", "subnet-08081ec18faebf7ac", "subnet-00540c9cac18e133f"]
  }


  tags = {
    Environment = "production"
  }
}

# Create an IAM role for the EKS cluster
resource "aws_iam_role" "example" {
  name = "eks-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach required policies to the IAM role
resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create a kubeconfig file for accessing the EKS cluster
data "aws_eks_cluster_auth" "example" {
  name           = aws_eks_cluster.example.name
  #kubeconfig     = "eksconfig"
  depends_on     = [aws_eks_cluster.example]
}

/*
output "cluster_info" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.example
}
*/


output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.example.endpoint
}


output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = aws_eks_cluster.example.vpc_config[0].cluster_security_group_id
}


output "region" {
  description = "AWS region"
  value       = "us-west-2"
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.example.name
}



## EKS Node Group Installation & Respective Roles 

resource "aws_iam_role" "example2" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.example2.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example2.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.example2.name
}


resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "example"
  node_role_arn   = aws_iam_role.example2.arn
  #subnet_ids      = aws_subnet.example[*].id
  #subnet_ids = ["subnet-0dd44d0c0b546abb4", "subnet-0e435d75327b592c3"]
  subnet_ids = ["subnet-0ca4711696dff18e0", "subnet-08081ec18faebf7ac", "subnet-00540c9cac18e133f"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}
