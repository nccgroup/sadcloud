# # Creates a single VPC with a subnet, internet gateway, and associated route table.
module "network" {
  source = "../network"
  needs_network = true
}

resource "aws_s3_bucket" "access_logging" {
  bucket_prefix = var.name
  acl    = "private"

  count = "${var.no_access_logs ? 0 : 1}"
}

resource "aws_lb" "main" {
  load_balancer_type = "application"
  enable_deletion_protection = !var.no_deletion_protection
  subnets = ["${module.network.main_subnet_id}","${module.network.secondary_subnet_id}"]

  access_logs {
    bucket  = "${aws_s3_bucket.access_logging[0].bucket_prefix}"
    enabled = !var.no_access_logs
  }

  count = "${(var.older_ssl_policy || var.no_access_logs || var.no_deletion_protection) ? 1 : 0}"
}

resource "aws_lb_target_group" "main" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.network.vpc_id}"

  count = "${var.older_ssl_policy ? 1 : 0}"

  depends_on = [
    "module.network"
  ]
}

resource "aws_iam_server_certificate" "main" {
  name = "test_cert"
  certificate_body = file(
    "${path.module}/example.crt.pem",
  )
  private_key = file(
    "${path.module}/example.key.pem",
  )

  count = "${var.older_ssl_policy ? 1 : 0}"
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = "${aws_lb.main[0].arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.older_ssl_policy ? "ELBSecurityPolicy-TLS-1-0-2015-04" : "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "${aws_iam_server_certificate.main[0].arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.main[0].arn}"
  }

  count = "${var.older_ssl_policy ? 1 : 0}"
}
