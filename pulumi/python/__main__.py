import pulumi
from pulumi_aws import s3

from techtalk import network

# Create an AWS resource (S3 Bucket)
# bucket = s3.Bucket('techtalkfridays-pulumi')

# Export the name of the bucket
#pulumi.export('bucket_name',  bucket.id)

network.make()
