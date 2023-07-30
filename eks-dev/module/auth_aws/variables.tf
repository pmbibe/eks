variable "manage_aws_auth_configmap" {
  description = "Determines whether to manage the aws-auth configmap"
  type        = bool
  default     = false
}

variable "create_aws_auth_configmap" {
  description = "Determines whether to create the aws-auth configmap. NOTE - this is only intended for scenarios where the configmap does not exist (i.e. - when using only self-managed node groups). Most users should use `manage_aws_auth_configmap`"
  type        = bool
  default     = false
}

variable "aws_auth_node_iam_role_arns_non_windows" {
  description = "List of non-Windows based node IAM role ARNs to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}

variable "aws_auth_node_iam_role_arns_windows" {
  description = "List of Windows based node IAM role ARNs to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}

variable "aws_auth_fargate_profile_pod_execution_role_arns" {
  description = "List of Fargate profile pod execution role ARNs to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_accounts" {
  description = "List of account maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  type = any
  default = {}
}

variable "self_managed_node_groups" {
  description = "Map of attribute maps for all self managed node groups created"
  type = any
  default = {
      dev-node-groups = {
          platform = "bottlerocket"
          iam_role_arn = "arn:aws:iam::000000000000:role/dev-node-groups-node-group-20230730071449110900000001"
        }
    }
}

variable "fargate_profiles" {
  description = "Map of attribute maps for all EKS Fargate Profiles created"
  type = any
  default = {}
}
