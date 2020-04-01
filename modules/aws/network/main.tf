
# create vpc
resource "aws_vpc" "main" {
  count = var.needs_network ? 1 : 0
  cidr_block = "10.0.0.0/16"

  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames = true # need to be enabled in order for publicly accessible RDS instance finding to work
  enable_dns_support = true # need to be enabled in order for publicly accessible RDS instance finding to work

  tags = {
    Name = "${var.name}_vpc"
  }
}

# grab AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# create subnet
resource "aws_subnet" "main" {
  count = var.needs_network ? 1 : 0
  vpc_id     = aws_vpc.main[0].id
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  ipv6_cidr_block = cidrsubnet(aws_vpc.main[0].ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "${var.name}_subnet"
  }
}

resource "aws_subnet" "secondary" {
  count = var.needs_network ? 1 : 0
  vpc_id     = aws_vpc.main[0].id
  cidr_block = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
}

# create internet gateway
resource "aws_internet_gateway" "main" {
  count = var.needs_network ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  tags = {
    Name = "${var.name}_ig"
  }
}

# create route table
resource "aws_route_table" "main" {
  count = var.needs_network ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  route {
      ipv6_cidr_block = "::/0"
      gateway_id = aws_internet_gateway.main[0].id
  }

  tags = {
    Name = "${var.name}_routes"
  }
}

# associate route table with subnet
resource "aws_route_table_association" "main" {
  count = var.needs_network ? 1 : 0
  subnet_id      = aws_subnet.main[0].id
  route_table_id = aws_route_table.main[0].id
}
