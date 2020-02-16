variable "cluster_name" {
    description = "Cluster name"
    type        = string
    default     = "engineering"
}

variable "vpc_id" {
    description = "Id of the vpc to create the cluster in"
    type        = string
}

variable "eks_version" {
    description = "Version of the EKS cluster"
    type        = string
    default     = "1.14"
}

variable "common_tags" {
    description = "Map of tags to include for tagging all resources"
    type        = map
    default     = {
        Environment = "Engineering"
        Owner       = "Devops"
    }
}

variable "ssh_key" {
    description = "Name of ec2 ssh key"
    type        = string
}

variable "eks_cluster_subnet_ids" {
    description = "List of subnet ids to use for the clustger"
    type        = list(string)
}

variable "eks_cluster_worker_nodes" {
    description = "List of maps containing worker node configuration"
    type        = map
}