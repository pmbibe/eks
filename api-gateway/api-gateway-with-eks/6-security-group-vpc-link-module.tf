module "vpc_link_service_sg" {

  source = "terraform-aws-modules/security-group/aws"

  name        = "vpc_link_service_sg"
  description = "Security group for VPC_link"
  vpc_id      = module.vpc.vpc_id
  egress_with_cidr_blocks = [
    {
      description = "Node groups to cluster API"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  depends_on = [module.vpc]


}