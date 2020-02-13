module "engineering-base-infra" {

    source = "../modules/base-infra"

    region = "us-east-1"
    name = "engineering"
    eks_cluster = "engineering"
    vpc_cidr = "10.0.0.0/16"
    worker_node_subnets = {
        "us-east-1a" = "10.0.0.0/20"
        "us-east-1b" = "10.0.16.0/20"
        "us-east-1c" = "10.0.32.0/20"
    }
    eks_cluster_subnets = {
        "us-east-1a" = "10.1.0.0/24"
        "us-east-1b" = "10.1.1.0/24"
        "us-east-1c" = "10.1.2.0/24"
    }
    alb_subnets = {
        "us-east-1a" = "10.1.3.0/24"
        "us-east-1b" = "10.1.4.0/24"
        "us-east-1c" = "10.1.5.0/24"
    }
    common_tags = {
        Environment = "Engineering"
        Owner       = "Devops"
    }
}