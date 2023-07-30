terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/security-group/aws//.?version=5.1.0"
}

include "root" {
  path = find_in_parent_folders()
}
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "vpc_mock"
  }  
  # skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}

locals {

}
inputs = {
  create_sg = true
  name                   = "dev-cluster-sg"
  description            = "EKS cluster security group"
  vpc_id                 = dependency.vpc.outputs.vpc_id
  tags = {
    "Name" = "dev-cluster-sg"
  }
}

