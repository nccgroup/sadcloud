resource "aws_acm_certificate" "main" {
  count = var.certificate_transparency_disabled ? 1 : 0
  domain_name       = "example.com"
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = var.certificate_transparency_disabled ? "DISABLED" : "ENABLED"
  }
}
