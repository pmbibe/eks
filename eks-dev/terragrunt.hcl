terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws//.?version=5.1.1"
}


include "root" {
  path   = find_in_parent_folders()
}

inputs = {




}