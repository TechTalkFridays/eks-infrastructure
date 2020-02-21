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

resource "aws_iam_role" "kuberentes-external-secrets" {
  name = "kuberentes-external-secrets-${var.cluster_name}"
  assume_role_policy =  templatefile("${path.module}/oidc_assume_role_policy.json", { OIDC_ARN = aws_iam_openid_connect_provider.main.arn, OIDC_URL = replace(aws_iam_openid_connect_provider.main.url, "https://", ""), NAMESPACE = "shared-services", SA_NAME = "kubernetes-external-secrets" })
  depends_on = [aws_iam_openid_connect_provider.main]
}


resource "aws_iam_role_policy_attachment" "aws_node" {
  role       = aws_iam_role.kuberentes-external-secrets.name
  policy_arn = aws_iam_policy.kuberentes-external-secrets.arn
}