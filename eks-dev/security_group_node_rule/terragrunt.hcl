terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/security-group/aws//.?version=5.1.0"
}

include "root" {
  path = find_in_parent_folders()
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
  create_sg = false
  security_group_id = dependency.cluster_sg_id.outputs.security_group_id
  engress_rules = {
    egress_all = {
      description      = "Allow all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }
  ingress_with_self = [
    {
      description = "Node to node CoreDNS"
      protocol    = "tcp"
      from_port   = 53
      to_port     = 53
      self        = true
    },
    {
      description = "Node to node CoreDNS UDP"
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
      self        = true
    },
    {
      description = "Node to node ingress on ephemeral ports"
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535
      self        = true
    }
]
  
  computed_ingress_with_source_security_group_id = [
    {
      description                   = "Cluster API to node groups"
      protocol                      = "tcp"
      from_port                     = 443
      to_port                       = 443
      source_security_group_id = dependency.cluster_sg_id.outputs.security_group_id
    },
    {
      description                   = "Cluster API to node kubelets"
      protocol                      = "tcp"
      from_port                     = 10250
      to_port                       = 10250
      source_security_group_id = dependency.cluster_sg_id.outputs.security_group_id
    },
    # metrics-server
    {
      description                   = "Cluster API to node 4443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 4443
      to_port                       = 4443
      source_security_group_id = dependency.cluster_sg_id.outputs.security_group_id
    },
    # prometheus-adapter
    {
      description                   = "Cluster API to node 6443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 6443
      to_port                       = 6443
      source_security_group_id = dependency.cluster_sg_id.outputs.security_group_id
    },
    # Karpenter
    {
      description                   = "Cluster API to node 8443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      source_security_group_id = dependency.cluster_sg_id.outputs.security_group_id
    },
    # ALB controller, NGINX
    {
      description                   = "Cluster API to node 9443/tcp webhook"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_security_group_id = dependency.cluster_sg_id.outputs.security_group_id
    }

  ]  
  }  



