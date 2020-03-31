output "cloudformation_template_body" {
  description = "the template body"
  value       = length(aws_cloudformation_stack.main) > 0 ? aws_cloudformation_stack.main[0].template_body : null
}
