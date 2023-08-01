module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "5.1.1"
  name                 = "VPC"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  private_subnets      = ["10.0.16.0/20", "10.0.32.0/20"]
  private_subnet_names = ["dev-private-us-east-1a", "dev-private-us-east-1b"]
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/dev-cluster" = "owned"
  }
  public_subnets      = ["10.0.49.0/24", "10.0.50.0/24", "10.0.51.0/24"]
  public_subnet_names = ["dev-public-us-east-1a", "dev-public-us-east-1b"]
  public_subnet_tags = {
    "kubernetes.io/role/elb"            = "1"
    "kubernetes.io/cluster/dev-cluster" = "owned"
  }

  #  private subnets that should have no Internet routing
  # cidrsubnet(prefix, newbits, netnum)
  intra_subnets          = ["10.0.53.0/24", "10.0.54.0/24", "10.0.55.0/24"]
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  create_igw             = true
}
