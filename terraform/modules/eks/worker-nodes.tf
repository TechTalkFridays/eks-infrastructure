#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "eks-workernode-sts" {
  name = "eks-worker-node-sts"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-workernode-sts.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-workernode-sts.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-workernode-sts.name
}

/*
Convert managed node groups to manually provisioning ASGs. This will allow us to add target groups to worker node ASGs.
*/
resource "aws_eks_node_group" "worker_node" {
  for_each = var.eks_cluster_worker_nodes

  cluster_name    = aws_eks_cluster.main.name
  node_role_arn   = aws_iam_role.eks-workernode-sts.arn
  node_group_name = each.value.name 
  subnet_ids      = each.value.subnet_ids 
  instance_types  = each.value.instance_types
  disk_size       = each.value.disk_size

  remote_access {
    ec2_ssh_key = var.ssh_key
  }

  scaling_config {
    desired_size = each.value.desired_size 
    max_size     = each.value.max_size 
    min_size     = each.value.min_size 
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
