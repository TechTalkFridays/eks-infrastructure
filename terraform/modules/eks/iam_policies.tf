resource "aws_iam_policy" "kuberentes-external-secrets" {
  name        = "kuberentes-external-secrets"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "kms:Decrypt",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": [
                "arn:aws:kms:*:*:key/*",
                "arn:aws:secretsmanager:*:*:secret:*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:GetRandomPassword",
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "node-autoscaler" {
  name        = "node-autoscaler"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "kuberentes-external-secrets" {
  policy_arn = aws_iam_policy.kuberentes-external-secrets.arn
  role       = aws_iam_role.eks-workernode-sts.name
}

resource "aws_iam_role_policy_attachment" "node-autoscaler" {
  policy_arn = aws_iam_policy.node-autoscaler.arn
  role       = aws_iam_role.eks-workernode-sts.name
}