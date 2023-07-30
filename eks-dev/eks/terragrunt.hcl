terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/eks/aws//.?version=19.15.4"
}

include "root" {
  path   = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "vpc_mock"
    private_subnets = ["10.0.16.0/20","10.0.32.0/20"]
    intra_subnets = ["10.0.49.0/24","10.0.50.0/24","10.0.51.0/24"]
  }  
  # skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}

dependency "cluster_sg_id" {
  config_path = "../security_group_cluster_name"
  mock_outputs = {
    security_group_id = "security_group_id_mock"
  }  
  # skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}

dependency "node_sg_id" {
  config_path = "../security_group_node_name"
  mock_outputs = {
    security_group_id = "security_group_id_mock"
  }  
  # skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}


locals {

}
inputs = {
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
  create_cluster_security_group = false
  cluster_security_group_id = dependency.cluster_sg_id.outputs.security_group_id
  create_node_security_group = false
  node_security_group_id = dependency.node_sg_id.outputs.security_group_id
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
  # manage_aws_auth_configmap = true
  vpc_id                    = dependency.vpc.outputs.vpc_id
  subnet_ids                = dependency.vpc.outputs.private_subnets # recommend deploying your nodes to private subnets
  control_plane_subnet_ids  = dependency.vpc.outputs.intra_subnets
  # create_aws_auth_configmap = true
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
      ami_id        = "ami-031aaabc376771a72"
      desired_size  = 2
      instance_type = "t2.small"
      key_name      = "MacBook"
    }
  }
}

