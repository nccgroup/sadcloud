resource "aws_elb" "main" {
  name               = var.name
  availability_zones = ["us-east-1a"]
  count = var.no_access_logs ? 1 : 0

  dynamic "access_logs" {
    for_each = var.no_access_logs == true ? [] : list(var.no_access_logs)

    content {
      bucket        = "foo"
      bucket_prefix = "bar"
      interval      = 60
    }
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
