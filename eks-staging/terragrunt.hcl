terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/eks/aws//.?version=19.15.3"
}


include "root" {
  path   = find_in_parent_folders()
}

inputs = {
  
}