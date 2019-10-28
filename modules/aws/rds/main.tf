# Creates a single VPC with a subnet, internet gateway, and associated route table.
module "network" {
  source = "../network"
  name = "rds-sadcloud"

  # TODO: this is a workaround until we can add counts to modules
  needs_network = false || var.no_minor_upgrade || var.backup_disabled || var.storage_not_encrypted || var.single_az
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [module.network.main_subnet_id, module.network.secondary_subnet_id]
  count = "${var.no_minor_upgrade || var.backup_disabled || var.storage_not_encrypted || var.single_az ? 1 : 0}"

  depends_on = [
    "module.network"
  ]
}

resource "aws_db_instance" "main" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  name                 = var.name
  username             = "foo"
  password             = "foobarbaz"
  skip_final_snapshot = true

  auto_minor_version_upgrade = "${var.no_minor_upgrade ? false : true}"
  storage_encrypted          = "${var.storage_not_encrypted ? false : true}"
  backup_retention_period    = "${var.backup_disabled ? 0 : 1}"
  multi_az = "${var.single_az ? false : true}"
  db_subnet_group_name = aws_db_subnet_group.default[0].name

  count = "${var.no_minor_upgrade || var.backup_disabled || var.storage_not_encrypted || var.single_az ? 1 : 0}"

  depends_on = [
    "module.network"
  ]
}
