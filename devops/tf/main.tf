terraform {
    required_version = ">= 1.3"
    required_providers {
        linode = {
            source = "linode/linode"
            version = "1.29.2"
        }
    }
    backend "s3" {
        skip_credentials_validation = true
        skip_region_validation = true
    }
}

provider "linode" {
    token = var.linode_pa_token
}