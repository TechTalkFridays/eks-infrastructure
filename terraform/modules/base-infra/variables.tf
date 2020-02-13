variable "name" {
    description = "Used for naming resources"
    type        = string
    default     = "Engineering"
}

variable "common_tags" {
    description = "Map of tags to include for tagging all resources"
    type        = map
    default     = {
        Environment = "Engineering"
        Owner       = "Devops"
    }
}

variable "region" {
    description = "Region to provision resources in"
    type        = string
    default     = "us-east-1"
}

variable "eks_cluster" {
    description = "Name of the EKS cluster that will reside in the VPC."
    type        = string
    default     = "engineering"
}

variable "vpc_cidr" {
    description = "Cidr of the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "worker_node_subnets" {
    description = "Map of private worker node subnets"
    type        = map
    default = {
        "us-east-1a" = "10.0.0.0/20"
        "us-east-1b" = "10.0.16.0/20"
        "us-east-1c" = "10.0.32.0/20"
    }
}

variable "eks_cluster_subnets" {
    description = "Map of public eks cluster subnets"
    type        = map
    default = {
        "us-east-1a" = "10.1.0.0/24"
        "us-east-1b" = "10.1.1.0/24"
        "us-east-1c" = "10.1.2.0/24"
    }
}

variable "alb_subnets" {
    description = "Map of public ALB subnets"
    type        = map
    default = {
        "us-east-1a" = "10.1.3.0/24"
        "us-east-1b" = "10.1.4.0/24"
        "us-east-1c" = "10.1.5.0/24"
    }
}
