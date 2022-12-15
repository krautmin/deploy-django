resource "linode_firewall" "app_node-firewall" {
  label = "app_node-firewall"
  tags = ["app", "app-node", "app-node-firewall"]

  inbound {
    label = "ssh-inbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "22"
    ipv4 = ["0.0.0.0/0"]
  }

  inbound {
    label = "http-inbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "80"
    ipv4 = ["192.168.255.0/24"]
  }

  inbound {
    label = "redis-inbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "6379"
    ipv4 = ["${linode_instance.app_redis.private_ip_address}/32"]
  }

  outbound {
    label = "redis-outbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "6379"
    ipv4 = ["${linode_instance.app_redis.private_ip_address}/32"]
  }

  outbound_policy = "ACCEPT"
  inbound_policy = "DROP" 
  linodes = [for host in linode_instance.app_vm.*: "${host.id}"]
}

resource "linode_firewall" "app_worker-firewall" {
  label = "app_worker-firewall"
  tags = ["app", "app-worker", "app-worker-firewall"]

  inbound {
    label = "ssh-inbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "22"
    ipv4 = ["0.0.0.0/0"]
  }

  inbound {
    label = "redis-inbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "6379"
    ipv4 = ["${linode_instance.app_redis.private_ip_address}/32"]
  }

  outbound {
    label = "redis-outbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "6379"
    ipv4 = ["${linode_instance.app_redis.private_ip_address}/32"]
  }

  outbound_policy = "ACCEPT"
  inbound_policy = "DROP" 
  linodes = [for host in linode_instance.app_worker.*: "${host.id}"]
}

resource "linode_firewall" "app_redis-firewall" {
  label = "app_redis-firewall"
  tags = ["app", "app-redis", "app-redis-firewall"]

  inbound {
    label = "ssh-inbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "22"
    ipv4 = ["0.0.0.0/0"]
  }

  inbound {
    label = "redis-inbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "6379"
    ipv4 = concat([for host in linode_instance.app_vm.*: "${host.private_ip_address}/32"], [for host in linode_instance.app_worker.*: "${host.private_ip_address}/32"])
  }

  outbound {
    label = "redis-outbound"
    protocol = "TCP"
    action   = "ACCEPT"
    ports = "6379"
    ipv4 = concat([for host in linode_instance.app_vm.*: "${host.private_ip_address}/32"], [for host in linode_instance.app_worker.*: "${host.private_ip_address}/32"])
  }

  outbound_policy = "ACCEPT"
  inbound_policy = "DROP"  
  linodes = ["${linode_instance.app_redis.id}"]
}