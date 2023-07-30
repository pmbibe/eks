terraform {
    source = "../module/auth_aws"
}


include "root" {
  path   = find_in_parent_folders()
}


dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    cluster_name = "mock-cluster-name"
    cluster_endpoint = "https://mock-cluster-endpoint.gr7.us-east-1.eks.amazonaws.com"
    cluster_certificate_authority_data = base64encode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K")
    self_managed_node_groups = {
      dev-node-groups = {
          platform = "bottlerocket"
          iam_role_arn = "arn:aws:iam::000000000000:role/dev-node-groups-node-group-20230730071449110900000001"
        }
    }

  }  
  # skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}

generate "eks_provider" {
  path      = "eks.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
provider "kubernetes" {
  host                   = "${dependency.eks.outputs.cluster_endpoint}"
  cluster_ca_certificate = base64decode("${dependency.eks.outputs.cluster_certificate_authority_data}")
  # For short-lived authentication tokens, like those found in EKS, which expire in 15 minutes, an exec-based credential plugin can be used to ensure the token is always up to date:
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", "${dependency.eks.outputs.cluster_name}"]
  }
}
EOF
}

inputs = {
  self_managed_node_groups = dependency.eks.outputs.self_managed_node_groups
}

