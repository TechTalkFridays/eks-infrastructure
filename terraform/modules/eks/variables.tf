variable "cluster_name" {
    description = "Cluster name"
    type        = string
    default     = "engineering"
}

variable "vpc_id" {
    description = "Id of the vpc to create the cluster in"
    type        = string
}

variable "common_tags" {
    description = "Map of tags to include for tagging all resources"
    type        = map
    default     = {
        Environment = "Engineering"
        Owner       = "Devops"
    }
}

variable "eks_cluster_subnet_ids" {
    description = "List of subnet ids to use for the clustger"
    type        = list(string)
}

variable "eks_cluster_worker_nodes" {
    description = "List of maps containing worker node configuration"
    type        = map
    /*default = [{
        name = "default"
        subnet_ids = []
        desired_size = 1
        max_size = 1
        min_size = 1
    }]*/
}