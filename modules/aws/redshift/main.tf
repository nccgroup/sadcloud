resource "aws_redshift_subnet_group" "main" {
  name       = "main"
  subnet_ids = [var.main_subnet_id]

  count = (var.parameter_group_ssl_not_required || var.parameter_group_logging_disabled || var.cluster_publicly_accessible || var.cluster_no_version_upgrade || var.cluster_database_not_encrypted) ? 1 : 0
}

resource "aws_redshift_parameter_group" "main" {
  name   = "parameter-group-test-sadcloud"
  family = "redshift-1.0"
  count = (var.parameter_group_ssl_not_required || var.parameter_group_logging_disabled) ? 1 : 0

  parameter {
    name  = "require_ssl"
    value = !var.parameter_group_ssl_not_required
  }

  parameter {
    name  = "enable_user_activity_logging"
    value = !var.parameter_group_logging_disabled
  }
}

resource "aws_redshift_cluster" "main" {
  cluster_identifier = var.name
  master_username    = "foo"
  master_password    = "Password1"
  node_type          = "dc1.large"
  cluster_type       = "single-node"
  skip_final_snapshot =  true
  allow_version_upgrade = !var.cluster_no_version_upgrade
  encrypted = !var.cluster_database_not_encrypted
  cluster_subnet_group_name = aws_redshift_subnet_group.main[0].name

  count = (var.parameter_group_ssl_not_required || var.parameter_group_logging_disabled || var.cluster_publicly_accessible || var.cluster_no_version_upgrade || var.cluster_database_not_encrypted) ? 1 : 0
}
