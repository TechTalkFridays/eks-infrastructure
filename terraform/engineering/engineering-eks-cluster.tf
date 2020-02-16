module "engineering-eks-cluster" {
    source = "../modules/eks"

    cluster_name = "engineering"
    vpc_id = module.engineering-base-infra.vpc_id
    eks_cluster_subnet_ids = module.engineering-base-infra.eks_cluster_subnets
    ssh_key = "joel-desktop"

    eks_cluster_worker_nodes = {
        default = {
            name = "default"
            subnet_ids = module.engineering-base-infra.worker_node_subnets
            desired_size = 1
            max_size = 1
            min_size = 1
            instance_types = ["t3.medium"]
            disk_size = "20"
        }
    }
    
}