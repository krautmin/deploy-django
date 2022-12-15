resource "linode_nodebalancer" "app_nodebalancer" {
    label = "app_nodebalancer"
    region = var.region
    tags = ["app-nodebalancer"]
}

resource "linode_nodebalancer_config" "app_nodebalancer-config" {
    nodebalancer_id = linode_nodebalancer.app_nodebalancer.id
    port = 80
    protocol = "https"
    check = "http"
    check_path = "/de/healthcheck"
    check_attempts = 5
    check_timeout = 30
    check_interval = 31
    stickiness = "table"
    algorithm = "roundrobin"
    ssl_cert = file(var.ssl_certificate)
    ssl_key = file(var.ssl_key)
}

resource "linode_nodebalancer_config" "app_nodebalancer-ssl-config" {
    nodebalancer_id = linode_nodebalancer.app_nodebalancer.id
    port = 443
    protocol = "https"
    check = "http"
    check_path = "/de/healthcheck"
    check_attempts = 5
    check_timeout = 30
    check_interval = 31
    stickiness = "table"
    algorithm = "roundrobin"
    ssl_cert = file(var.ssl_certificate)
    ssl_key = file(var.ssl_key)
}

resource "linode_nodebalancer_node" "app_nodebalancer-node" {
    count = var.app_instance_vm_count > 0 ? var.app_instance_vm_count : 0
    nodebalancer_id = linode_nodebalancer.app_nodebalancer.id
    config_id = linode_nodebalancer_config.app_nodebalancer-config.id
    label = "app_node-${count.index + 1}"
    address = "${element(linode_instance.app_vm.*.private_ip_address, count.index)}:80"
    mode = "accept"
}

resource "linode_nodebalancer_node" "app_nodebalancer-ssl-node" {
    count = var.app_instance_vm_count > 0 ? var.app_instance_vm_count : 0
    nodebalancer_id = linode_nodebalancer.app_nodebalancer.id
    config_id = linode_nodebalancer_config.app_nodebalancer-ssl-config.id
    label = "app_node-ssl-${count.index + 1}"
    address = "${element(linode_instance.app_vm.*.private_ip_address, count.index)}:80"
    mode = "accept"
}