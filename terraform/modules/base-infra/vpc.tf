resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags       = merge(var.common_tags, map(
    "Name", "${var.name}",
    ))
}

resource "aws_eip" "nat_gateway" {
  vpc      = true
  tags     = merge(var.common_tags, map("Name", "Worker Node Egress IP"))
}

resource "aws_nat_gateway" "worker_node_nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.alb_subnets["us-east-1a"].id
  tags          = merge(var.common_tags, map("Name", "Worker Node Nat Gateway"))
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.common_tags, map("Name", "Internet gateway"))
}