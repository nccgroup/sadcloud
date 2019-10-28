output "cloudformation_template_body" {
  description = "the template body"
  value       = aws_cloudformation_stack.main[0].template_body
}
