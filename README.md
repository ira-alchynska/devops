## devops — Terraform AWS (lesson-5)

This repository contains Terraform configuration for a lesson covering an S3 remote backend, VPC, and ECR on AWS.

Repository structure

```
.
├── main.tf
├── backend.tf
├── outputs.tf
└── modules/
    ├── s3-backend/
    │   ├── s3.tf
    │   ├── dynamodb.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── vpc/
    │   ├── vpc.tf
    │   ├── routes.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ecr/
        ├── ecr.tf
        ├── variables.tf
        └── outputs.tf
```

Quick commands

- Initialize (local state):

  terraform init

- Plan changes:

  terraform plan

- Apply changes:

  terraform apply -auto-approve

Enable remote backend (S3 + DynamoDB)

1. Create the S3 bucket and DynamoDB table (see `modules/s3-backend`). The S3 bucket should have versioning and encryption enabled. DynamoDB is used for state locking.
2. Update `backend.tf` with your unique bucket name, key, region and DynamoDB table name.
3. Run:

  terraform init -migrate-state

Workflow notes

- After the backend is configured, use the normal workflow:

  terraform plan
  terraform apply

- Destroying resources when using the S3 backend:
  If the S3 bucket in `backend.tf` is being used as the remote backend, migrate state back to local or to another backend before deleting the bucket. Example steps to migrate back to local:

  mv backend.tf backend.tf.disabled
  terraform init -reconfigure
  terraform destroy -auto-approve

Important implementation details

- S3 backend: versioning and encryption enabled. DynamoDB table for state locking.
- VPC: three public and three private subnets, Internet Gateway, one NAT gateway, and appropriate route tables.
- ECR: repository with image scan-on-push enabled and a lifecycle policy that keeps the last 10 images.

Cleanup behavior

- The S3 module in this repo sets `force_destroy = true` on the bucket. That means Terraform will empty the bucket (including object versions) when destroying it. Use caution when destroying resources.

Contact / further notes

If you need adjustments (add examples, CI integration, or provider pinning), tell me which part to expand and I will update the README.
