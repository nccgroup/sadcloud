resource "aws_lightsail_instance" "main" {
  name              = "sadcloud_lightsail"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2018_03_0_2"
  bundle_id         = "nano_2_0"

  count = var.lightsail_in_use ? 1 : 0
}
