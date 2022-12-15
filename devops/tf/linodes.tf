resource "linode_instance" "app_vm" {
    count = var.app_instance_vm_count > 0 ? var.app_instance_vm_count : 0
    label = "app_django-${count.index + 1}"
    group = "app_nodebalancer"
    image = var.linode_image
    region = var.region
    type = var.linode_type
    authorized_keys = [ var.authorized_key ]
    root_pass = var.root_user_pw
    private_ip = true
    tags = ["app", "app-node", "app-nodebalancer"]
}

resource "linode_instance" "app_redis" {
    image = var.linode_image
    label = "app_redis"
    region = var.region
    type = var.linode_type
    authorized_keys = [ var.authorized_key]
    root_pass = var.root_user_pw
    private_ip = true
    tags = ["app", "app-redis"]
}

resource "linode_instance" "app_worker" {
    image = var.linode_image
    label = "app_worker"
    region = var.region
    type = var.linode_type
    authorized_keys = [ var.authorized_key]
    root_pass = var.root_user_pw
    private_ip = true
    tags = ["app", "app-worker"]

    depends_on = [linode_instance.app_redis]
}