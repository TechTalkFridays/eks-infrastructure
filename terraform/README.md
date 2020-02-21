# Infrastructure provisioning 

First lets manually create a S3 bucket to hold our TF state. Without a remote TF state and state locking, we can get into some nasty scenarios when more than one person is working on IAC.

Create a unique s3 bucket
```bash
aws s3api create-bucket --bucket techtalkfridays-terraform-state --region us-east-1
```

Update configuration for the engineering env:
- Update main.tf with your s3 bucket name.
- Update cidrs, resources names, etc..

Run terraform
```bash
terraform init
terraform plan
terraform apply
```