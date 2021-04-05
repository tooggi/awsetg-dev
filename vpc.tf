data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zone_names = data.aws_availability_zones.available.names
  az_number = length(local.availability_zone_names)
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-Main-VPC"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.prefix}-Main-IGW"
  }
}

resource "aws_subnet" "public_subnets" {
  count = local.az_number

  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = local.availability_zone_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-Public-Subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = local.az_number

  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + local.az_number)
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = local.availability_zone_names[count.index]

  tags = {
    Name = "${var.prefix}-Private-Subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.prefix}-Public-Route-Table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.prefix}-Private-Route-Table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count = length(aws_subnet.public_subnets)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table_association" "private_route_table_association" {
  count = length(aws_subnet.private_subnets)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.private_subnets[count.index].id
}

resource "aws_route" "public_igw_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id
}

