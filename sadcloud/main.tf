############## Always leave uncommented! ##############
# Creates a single VPC with a subnet, internet gateway, and associated route table.
module "network" {
  source = "../modules/aws/network"

  # This is a workaround until Terraform supports dynamic modules or counts for modules
  needs_network = false || var.all_findings || var.all_ec2_findings || var.all_elbv2_findings || var.all_rds_findings || var.all_redshift_findings || var.all_eks_findings
}

############## SERVICES ##############

module "acm" {
  source = "../modules/aws/acm"

  certificate_transparency_disabled = false || var.all_acm_findings || var.all_findings
}

module "cloudformation" {
  source = "../modules/aws/cloudformation"

  stack_with_role = false || var.all_cloudformation_findings || var.all_findings
  stack_with_secret_output = false || var.all_cloudformation_findings || var.all_findings
}

module "cloudtrail" {
  source = "../modules/aws/cloudtrail"

  no_data_logging = false || var.all_cloudtrail_findings || var.all_findings
  no_global_services_logging = false || var.all_cloudtrail_findings || var.all_findings
  no_log_file_validation = false || var.all_cloudtrail_findings || var.all_findings
  no_logging = false || var.all_cloudtrail_findings || var.all_findings
  duplicated_global_services_logging = false || var.all_cloudtrail_findings || var.all_findings
  not_configured = false || var.all_cloudtrail_findings || var.all_findings
}

module "cloudwatch" {
  source = "../modules/aws/cloudwatch"

  alarm_without_actions = false || var.all_cloudwatch_findings || var.all_findings
}

module "config" {
  source = "../modules/aws/config"

  config_recorder_not_configured = false || var.all_config_findings || var.all_findings
}

module "ebs" {
  source = "../modules/aws/ebs"

  ebs_default_encryption_disabled = false || var.all_ebs_findings || var.all_findings
  ebs_volume_unencrypted = false || var.all_ebs_findings || var.all_findings
  ebs_snapshot_unencrypted = false || var.all_ebs_findings || var.all_findings
}

module "ec2" {
  source = "../modules/aws/ec2"

   main_subnet_id = module.network.main_subnet_id
   vpc_id = module.network.vpc_id

   disallowed_instance_type = false || var.all_ec2_findings || var.all_findings
   instance_with_public_ip = false || var.all_ec2_findings || var.all_findings
   instance_with_user_data_secrets = false || var.all_ec2_findings || var.all_findings
   security_group_opens_all_ports_to_all = false || var.all_ec2_findings || var.all_findings
   security_group_opens_all_ports_to_self = false || var.all_ec2_findings || var.all_findings
   security_group_opens_icmp_to_all = false || var.all_ec2_findings || var.all_findings
   security_group_opens_known_port_to_all = false || var.all_ec2_findings || var.all_findings
   security_group_opens_plaintext_port = false || var.all_ec2_findings || var.all_findings
   security_group_opens_port_range = false || var.all_ec2_findings || var.all_findings
   security_group_opens_port_to_all = false || var.all_ec2_findings || var.all_findings
   security_group_whitelists_aws_ip_from_banned_region = false || var.all_ec2_findings || var.all_findings
   security_group_whitelists_aws = false || var.all_ec2_findings || var.all_findings
   ec2_security_group_whitelists_unknown_cidrs = false || var.all_ec2_findings || var.all_findings
   ec2_unused_security_group = false || var.all_ec2_findings || var.all_findings
   ec2_unneeded_security_group = false || var.all_ec2_findings || var.all_findings
   ec2_unexpected_security_group = false || var.all_ec2_findings || var.all_findings
   ec2_overlapping_security_group = false || var.all_ec2_findings || var.all_findings
}

module "ecr" {
  source = "../modules/aws/ecr"

  ecr_scanning_disabled = false || var.all_ecr_findings || var.all_findings
  ecr_repo_public = false || var.all_ecr_findings || var.all_findings
}

module "eks" {
  source = "../modules/aws/eks"

  main_subnet_id = module.network.main_subnet_id
  secondary_subnet_id = module.network.secondary_subnet_id
  vpc_id = module.network.vpc_id

  out_of_date = false || var.all_eks_findings || var.all_findings
  no_logs = false || var.all_eks_findings || var.all_findings
  publicly_accessible = false || var.all_eks_findings || var.all_findings
  globally_accessible = false || var.all_eks_findings || var.all_findings
}

module "elasticsearch" {
  source = "../modules/aws/elasticsearch"

  elasticsearch_logging_disabled = false || var.all_elasticsearch_findings || var.all_findings
  elasticsearch_open_access = false || var.all_elasticsearch_findings || var.all_findings
}

module "elb" {
  source = "../modules/aws/elb"

  no_access_logs = false || var.all_elb_findings || var.all_findings
}

module "elbv2" {
  source = "../modules/aws/elbv2"

  main_subnet_id = module.network.main_subnet_id
  secondary_subnet_id = module.network.secondary_subnet_id
  vpc_id = module.network.vpc_id

  no_access_logs = false || var.all_elbv2_findings || var.all_findings
  no_deletion_protection = false || var.all_elbv2_findings || var.all_findings
  older_ssl_policy = false || var.all_elbv2_findings || var.all_findings
}

module "glacier" {
  source = "../modules/aws/glacier"

  glacier_public = false || var.all_glacier_findings || var.all_findings
}

module "iam" {
  source = "../modules/aws/iam"

  password_policy_minimum_length = false || var.all_iam_findings || var.all_findings
  password_policy_no_lowercase_required = false || var.all_iam_findings || var.all_findings
  password_policy_no_numbers_required = false || var.all_iam_findings || var.all_findings
  password_policy_no_uppercase_required = false || var.all_iam_findings || var.all_findings
  password_policy_no_symbol_required = false || var.all_iam_findings || var.all_findings
  password_policy_reuse_enabled = false || var.all_iam_findings || var.all_findings
  password_policy_expiration_threshold = false || var.all_iam_findings || var.all_findings
  managed_allows_passrole = false || var.all_iam_findings || var.all_findings
  inline_role_policy = false || var.all_iam_findings || var.all_findings
  inline_group_policy = false || var.all_iam_findings || var.all_findings
  inline_user_policy = false || var.all_iam_findings || var.all_findings
  assume_role_policy_allows_all = false || var.all_iam_findings || var.all_findings
  assume_role_no_mfa = false || var.all_iam_findings || var.all_findings
  admin_iam_policy = false || var.all_iam_findings || var.all_findings
  admin_not_indicated_policy = false || var.all_iam_findings || var.all_findings
}

module "kms" {
  source = "../modules/aws/kms"

  key_rotation_disabled = false || var.all_kms_findings || var.all_findings
  kms_key_exposed = false || var.all_kms_findings || var.all_findings
}

module "lightsail" {
  source = "../modules/aws/lightsail"

  lightsail_in_use = false || var.all_lightsail_findings || var.all_findings
}

module "rds" {
  source = "../modules/aws/rds"

  main_subnet_id = module.network.main_subnet_id
  secondary_subnet_id = module.network.secondary_subnet_id

  no_minor_upgrade = false || var.all_rds_findings || var.all_findings
  backup_disabled = false || var.all_rds_findings || var.all_findings
  storage_not_encrypted = false || var.all_rds_findings || var.all_findings
  single_az = false || var.all_rds_findings || var.all_findings
  rds_publicly_accessible = false || var.all_rds_findings || var.all_findings
}

module "redshift" {
  source = "../modules/aws/redshift"

  main_subnet_id = module.network.main_subnet_id

  parameter_group_ssl_not_required = false || var.all_redshift_findings || var.all_findings
  parameter_group_logging_disabled = false || var.all_redshift_findings || var.all_findings
  cluster_publicly_accessible = false || var.all_redshift_findings || var.all_findings
  cluster_no_version_upgrade = false || var.all_redshift_findings || var.all_findings
  cluster_database_not_encrypted = false || var.all_redshift_findings || var.all_findings
}

module "s3" {
  source = "../modules/aws/s3"

  allow_cleartext = false || var.all_s3_findings || var.all_findings
  no_default_encryption = false || var.all_s3_findings || var.all_findings
  no_logging = false || var.all_s3_findings || var.all_findings
  no_versioning = false || var.all_s3_findings || var.all_findings
  website_enabled = false || var.all_s3_findings || var.all_findings
  s3_getobject_only = false || var.all_s3_findings || var.all_findings
  s3_public = false || var.all_s3_findings || var.all_findings
}

module "ses" {
  source = "../modules/aws/ses"

  no_dkim_enabled = false || var.all_ses_findings || var.all_findings
  identity_world_policy  = false || var.all_ses_findings || var.all_findings
}


module "sns" {
  source = "../modules/aws/sns"

  topic_world_policy = false || var.all_sns_findings || var.all_findings
}

module "sqs" {
  source = "../modules/aws/sqs"

  queue_world_policy = false || var.all_sqs_findings || var.all_findings
  sqs_server_side_encryption_disabled = false || var.all_sqs_findings || var.all_findings
}
