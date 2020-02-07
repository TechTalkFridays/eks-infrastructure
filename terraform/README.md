# Infrastructure provisioning 

First lets manually create a S3 bucket to hold our TF state. Without a remote TF state and state locking, we can get into some nasty scenarios when more than one person is working on IAC.

```bash
Create a unique s3 bucket
```

Update terraform/production/main.tf with your s3 bucket name.
