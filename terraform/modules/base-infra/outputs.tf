output "vpc_id" {
    value = aws_vpc.main.id
}

output "eks_cluster_subnets" {
    value = [aws_subnet.eks_cluster_subnets["us-east-1a"].id, aws_subnet.eks_cluster_subnets["us-east-1b"].id, aws_subnet.eks_cluster_subnets["us-east-1c"].id]
}

output "worker_node_subnets" {
    value = [aws_subnet.worker_node_subnets["us-east-1a"].id, aws_subnet.worker_node_subnets["us-east-1b"].id, aws_subnet.worker_node_subnets["us-east-1c"].id]
}

output "alb_subnets" {
    value = [aws_subnet.alb_subnets["us-east-1a"].id, aws_subnet.alb_subnets["us-east-1b"].id, aws_subnet.alb_subnets["us-east-1c"].id]
}