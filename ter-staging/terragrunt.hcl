terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws//.?version=5.1.1"
}

include "root" {
    path = find_in_parent_folders()
}

inputs = {
  name                 = "staging-VPC"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  private_subnets      = ["10.0.0.0/19", "10.0.32.0/19"]
  private_subnet_names = ["staging-private-us-east-1a", "staging-private-us-east-1b"]
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/staging-demo"  = "owned"
  }
  public_subnets       = ["10.0.64.0/19", "10.0.96.0/19"]
  public_subnet_names = ["staging-public-us-east-1a", "staging-public-us-east-1b"]
  public_subnet_tags = {
    "kubernetes.io/role/elb"         = "1"
    "kubernetes.io/cluster/staging-demo" = "owned"
  }
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  create_igw             = true  
}