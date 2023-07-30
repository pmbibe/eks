generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "aws" {
    region = "us-east-1"
}

EOF
}

remote_state {
    backend = "local"
    generate = {
        path = "backend.tf" #File name
        if_exists = "overwrite_terragrunt"
    }
    config = {
        path = "${path_relative_to_include()}/terraform.tfstate"
    }
    # config = {
    #     bucket         = "my-terraform-state"
    #     key            = "${path_relative_to_include()}/terraform.tfstate"
    #     region         = "us-east-1"
    #     encrypt        = true
    #     dynamodb_table = "my-lock-table"
    # }
}
