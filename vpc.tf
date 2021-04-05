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

resource "aws_subnet" "public_subnets" {
  count = local.az_number

  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = local.availability_zone_names[count.index]

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


