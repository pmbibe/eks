
output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.cluster_arn
}

# output "cluster_certificate_authority_data" {
#   description = "Base64 encoded certificate data required to communicate with the cluster"
#   value       = module.eks.cluster_certificate_authority_data
# }

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_id" {
  description = "The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts"
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

# output "cluster_version" {
#   description = "The Kubernetes version for the cluster"
#   value       = try(aws_eks_cluster.this[0].version, null)
# }

# output "cluster_platform_version" {
#   description = "Platform version for the cluster"
#   value       = try(aws_eks_cluster.this[0].platform_version, null)
# }

# output "cluster_status" {
#   description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
#   value       = try(aws_eks_cluster.this[0].status, null)
# }

# output "aws_auth_configmap_yaml" {
#   description = "Formatted yaml output for base aws-auth configmap containing roles used in cluster node groups/fargate profiles"
#   value       = module.eks.aws_auth_configmap_yaml
# }

# output "cluster_primary_security_group_id" {
#   description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
#   value       = try(aws_eks_cluster.this[0].vpc_config[0].cluster_security_group_id, null)
# }