resource "linode_domain" "main_domain" {
    type = "master"
    domain = "domain.com"
    soa_email = "mail@domain.com"
    lifecycle {
      prevent_destroy = true
    }
}

resource "linode_domain_record" "domain_root_ipv4" {
    domain_id = linode_domain.main_domain.id
    name = "domain.com"
    record_type = "A"
    target = "${linode_nodebalancer.app_nodebalancer.ipv4}"
    lifecycle {
      prevent_destroy = true
    }
}

resource "linode_domain_record" "domain_root_ipv6" {
    domain_id = linode_domain.main_domain.id
    name = "domain.com"
    record_type = "AAAA"
    target = "${linode_nodebalancer.app_nodebalancer.ipv6}"
    lifecycle {
      prevent_destroy = true
    }
}

resource "linode_domain_record" "domain_www_ipv4" {
    domain_id = linode_domain.main_domain.id
    name = "www"
    record_type = "A"
    target = "${linode_nodebalancer.app_nodebalancer.ipv4}"
}

resource "linode_domain_record" "domain_www_ipv6" {
    domain_id = linode_domain.main_domain.id
    name = "www"
    record_type = "AAAA"
    target = "${linode_nodebalancer.app_nodebalancer.ipv6}"
}