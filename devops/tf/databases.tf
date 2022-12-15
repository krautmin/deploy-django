resource "linode_database_postgresql" "app_postgres" {
  label = "app_postgres"
  engine_id = "postgresql/13.2"
  region = var.region
  type = var.db_type

  allow_list = concat([for host in linode_instance.app_vm.*: "${host.private_ip_address}"], [for host in linode_instance.app_worker.*: "${host.private_ip_address}"], ["81.169.150.10/32"], ["0.0.0.0/0"])
  cluster_size = 3
  encrypted = true
  replication_type = "semi_synch"
  replication_commit_type = "remote_write"
  ssl_connection = true

  updates {
    day_of_week = "monday"
    duration = 1
    frequency = "weekly"
    hour_of_day = 4
  }
}

resource "local_file" "pgpass_file" {
    content = templatefile("${local.templates_dir}/.pgpass", {
                      password="${linode_database_postgresql.app_postgres.root_password}"
            })
    filename = "${local.tf_dir}/.pgpass"
}