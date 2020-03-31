# Use the Ubuntu 18.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.disallowed_instance_type ? "t2.micro" : "t2.small"
  subnet_id     = var.main_subnet_id
  count         = var.disallowed_instance_type || var.instance_with_user_data_secrets || var.instance_with_public_ip ? 1 : 0


  associate_public_ip_address = var.instance_with_public_ip
  user_data                   = var.instance_with_user_data_secrets ? "password,AKIAIOSFODNN7EXAMPLE" : null

  tags = {
    Name = var.name
  }
}

# Security Groups

resource "aws_security_group" "all_ports_to_all" {
  name  = "${var.name}-all_ports_to_all"
  count = var.security_group_opens_all_ports_to_all ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "all_ports_to_self" {
  name  = "${var.name}-all_ports_to_self"
  count = var.security_group_opens_all_ports_to_self ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "icmp_to_all" {
  name  = "${var.name}-icmp_to_all"
  count = var.security_group_opens_icmp_to_all ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "known_port_to_all" {
  name  = "${var.name}-known_port_to_all"
  count = var.security_group_opens_known_port_to_all ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22 # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25 # SMTP
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2049 # NFS
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306 # mysql
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017 # mongodb
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1433 # MsSQL
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1521 # Oracle DB
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432 # PostgreSQL
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389 # RDP
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53 # DNS
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "opens_plaintext_port" {
  name  = "${var.name}-opens_plaintext_port"
  count = var.security_group_opens_plaintext_port ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 21 # FTP
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 23 # Telnet
    to_port     = 23
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "opens_port_range" {
  name  = "${var.name}-opens_port_range"
  count = var.security_group_opens_port_range ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 21
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "opens_port_to_all" {
  name  = "${var.name}-opens_port_to_all"
  count = var.security_group_opens_port_to_all ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "whitelists_aws_ip_from_banned_region" {
  name  = "${var.name}-whitelists_aws_ip_from_banned_region"
  count = var.security_group_whitelists_aws_ip_from_banned_region ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["52.28.0.0/16"] # eu-central-1
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "whitelists_aws" {
  name  = "${var.name}-whitelists_aws"
  count = var.security_group_whitelists_aws ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["52.14.0.0/16"] # us-east-2
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "whitelists_unknown_cidrs" {
  name  = "${var.name}-whitelists_unknown_cidrs"
  count = var.ec2_security_group_whitelists_unknown_cidrs ? 1 : 0

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["8.8.8.8/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "unused_security_group" {
  name  = "${var.name}-unused_security_group"
  count = var.ec2_unused_security_group ? 1 : 0

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["8.8.8.8/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "unneeded_security_group" {
  name  = "${var.name}-unneeded_security_group"
  count = var.ec2_unneeded_security_group ? 1 : 0

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["127.0.0.0/8"]
  }
}

resource "aws_security_group" "unexpected_security_group" {
  name  = "${var.name}-unexpected_security_group"
  count = var.ec2_unexpected_security_group ? 1 : 0

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/8"]
  }
}

resource "aws_security_group" "overlapping_security_group" {
  name  = "${var.name}-overlapping_security_group"
  count = var.ec2_overlapping_security_group ? 1 : 0

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["162.168.2.0/24"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["162.168.2.0/25"]
  }
}
