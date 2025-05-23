terraform { 
  backend "local" { 
     path = "/var/tmp/terraform-local-backend-remote-state/terraform.tfstate"
  }

  required_providers {
    aws = { 
      source = "hashicorp/aws"
      version = ">=5.11"
    }
  }

}
