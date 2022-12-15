resource "local_file" "ansible_inventory" {
    content = templatefile("${local.templates_dir}/ansible-inventory.tpl", {
                      webapps=[for host in linode_instance.app_vm.*: "${host.ip_address} hostname=${host.label}"]
                      webappspriv=[for host in linode_instance.app_vm.*: "${host.private_ip_address}"]
                      nodebalancer="${linode_nodebalancer.app_nodebalancer.ipv4}"
                      nodebalancerhost="${linode_nodebalancer.app_nodebalancer.hostname}"
                      redis="${linode_instance.app_redis.ip_address} hostname=${linode_instance.app_redis.label}"
                      redispriv="${linode_instance.app_redis.private_ip_address}"
                      workers=[for host in linode_instance.app_worker.*: "${host.ip_address} hostname=${host.label}"]
                      workerspriv=[for host in linode_instance.app_worker.*: "${host.private_ip_address}"]
            })
    filename = "${local.ansible_dir}/inventory.ini"
}