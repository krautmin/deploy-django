variable "app_instance_vm_count" {
    default = 0
}

variable "app_extra_nodes" {
    default = "0"
}

variable "linode_pa_token" {
    sensitive = true
}

variable "authorized_key" {
    sensitive = true
}

variable "root_user_pw" {
    sensitive = true
}

variable "linode_image" {
    default = "linode/ubuntu22.04"
}

variable "region" {
    default = "eu-central"
}

variable "ssl_certificate" {
    sensitive = true
}

variable "ssl_key" {
    sensitive = true
}

variable "db_type" {
    default = "g6-standard-1"
}

variable "linode_type" {
    default = "g6-standard-1"
}