resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = var.vpc_name }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.vpc_name}-igw" }
}

# Public subnets
resource "aws_subnet" "public" {
  for_each = {
    for idx, cidr in var.public_subnets :
    idx => { cidr = cidr, az = var.availability_zones[idx] }
  }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.vpc_name}-public-${each.value.az}", Tier = "public" }
}

# Private subnets
resource "aws_subnet" "private" {
  for_each = {
    for idx, cidr in var.private_subnets :
    idx => { cidr = cidr, az = var.availability_zones[idx] }
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = { Name = "${var.vpc_name}-private-${each.value.az}", Tier = "private" }
}
