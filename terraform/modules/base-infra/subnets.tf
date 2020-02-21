resource "aws_route_table" "worker_node_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    // nat_gateway_id = aws_nat_gateway.worker_node_nat_gateway.id
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, map(
    "Name", "worker-node-route",
  ))

}

resource "aws_route_table" "public_rote" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, map(
    "Name", "public-route",
  ))
}

resource "aws_subnet" "worker_node_subnets" {
  for_each = var.worker_node_subnets

  availability_zone = each.key
  cidr_block        = each.value
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, map(
    "Name", "eks-worker-node-subnet-${each.key}",
    "kubernetes.io/role/internal-elb", "1",
    "kubernetes.io/cluster/${var.eks_cluster}", "shared"
    ))
}

resource "aws_route_table_association" "worker_node_subnets" {
  for_each = var.worker_node_subnets
  
  subnet_id      = aws_subnet.worker_node_subnets[each.key].id
  route_table_id = aws_route_table.worker_node_route.id
}

resource "aws_subnet" "eks_cluster_subnets" {
  for_each = var.eks_cluster_subnets

  availability_zone = each.key
  cidr_block        = each.value
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, map(
    "Name", "eks-cluster-subnet-${each.key}",
    "kubernetes.io/cluster/${var.eks_cluster}", "shared"
    ))
}

resource "aws_route_table_association" "eks_cluster_subnets" {
  for_each = var.eks_cluster_subnets

  subnet_id      = aws_subnet.eks_cluster_subnets[each.key].id
  route_table_id = aws_route_table.worker_node_route.id
}

resource "aws_subnet" "alb_subnets" {
  for_each = var.alb_subnets

  availability_zone = each.key
  cidr_block        = each.value
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, map(
    "Name", "ALB-subnets-${each.key}",
    "kubernetes.io/role/elb", "1",
    ))
}

resource "aws_route_table_association" "alb_subnets" {
  for_each = var.alb_subnets

  subnet_id      = aws_subnet.alb_subnets[each.key].id
  route_table_id = aws_route_table.worker_node_route.id
}