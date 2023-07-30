terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/security-group/aws//.?version=5.1.0"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "cluster_sg_id" {
  config_path = "../security_group_cluster_name"
  mock_outputs = {
    security_group_id = "cluster_security_group_id_mock"
  }  
  # skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan", "validate","init"]
}

dependency "node_sg_id" {
  config_path = "../security_group_node_name"
  mock_outputs = {
    security_group_id = "node_security_group_id_mock"
  }  
  # skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}

locals {

}
inputs = {
  create_sg = false
  security_group_id = dependency.cluster_sg_id.outputs.security_group_id
  computed_ingress_with_source_security_group_id = [
    {
      description                = "Node groups to cluster API"
      protocol                   = "tcp"
      from_port                  = "443"
      to_port                    = "443"
      source_security_group_id = dependency.node_sg_id.outputs.security_group_id
    }
  ]
  }

