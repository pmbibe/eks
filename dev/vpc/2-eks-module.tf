module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.15.4"
  cluster_name    = "dev-cluster"
  cluster_version = "1.27"
  # add-on
  # vpc-cni - provides native VPC networking
  # coredns
  # kubet-proxy - Maintains network rules on each Amazon EC2 node
  # aws-ebs-csi-driver -  provides Amazon EBS storage for your cluster
  # aws-efs-csi-driver - provides Amazon EFS storage for your cluster.
  # adot - metrics and/or trace collection pipeline - collect, and send infrastructure and application metrics from Amazon EKS clusters and applications to either Amazon Managed Service for Prometheus or CloudWatch.
  #      - collect and send application traces from workloads running on Amazon EKS to AWS X-Ray.
  # aws-guardduty-agent - security monitoring service
  cluster_endpoint_public_access = true
  cluster_addons = {
    # coredns = {
    #   most_recent = true
    #   resolve_conflicts_on_create = "PRESERVE"
    #   resolve_conflicts_on_update = "OVERWRITE"
    # }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
    }
    vpc-cni = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
    }
  }
  manage_aws_auth_configmap = true
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnets # recommend deploying your nodes to private subnets
  control_plane_subnet_ids  = module.vpc.intra_subnets
  create_aws_auth_configmap = true
  self_managed_node_group_defaults = {
    # enable discovery of autoscaling groups by cluster-autoscaler
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/dev-cluster" : "owned",
    }
  }
  self_managed_node_groups = {
    dev-node-groups = {
      name          = "dev-node-groups"
      platform      = "bottlerocket"
      ami_id        = data.aws_ami.eks_default_bottlerocket.id
      desired_size  = 2
      instance_type = "t2.small"
      key_name      = "MacBook"
    }
  }
}
data "aws_ami" "eks_default_bottlerocket" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-1.27-x86_64-*"]
  }
}
