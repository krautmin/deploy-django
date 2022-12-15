output "instances" {
    value = [for host in linode_instance.app_vm.*: "${host.label} : ${host.ip_address}"]
}

output "instancespriv" {
    value = [for host in linode_instance.app_vm.*: "${host.label} : ${host.private_ip_address}"]
}

output "nodebalancerip" {
    value = "${linode_nodebalancer.app_nodebalancer.ipv4}"
}

output "nodebalancerhost" {
    value = "${linode_nodebalancer.app_nodebalancer.hostname}"
}

output "redis" {
    value = "${linode_instance.app_redis.ip_address}"
}

output "redispriv" {
    value = "${linode_instance.app_redis.private_ip_address}"
}

output "workers" {
    value = "${linode_instance.app_worker.ip_address}"
}

output "workerspriv" {
    value = "${linode_instance.app_worker.private_ip_address}"
}

output "postgreshost" {
    value = "${linode_database_postgresql.app_postgres.host_primary}"
}

output "postgrespriv" {
    value = "${linode_database_postgresql.app_postgres.host_secondary}"
}