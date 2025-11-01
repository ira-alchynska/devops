# devops
# lesson-5 — Terraform AWS: S3 backend, VPC, ECR

## Structure
lesson-5/
├── main.tf
├── backend.tf
├── outputs.tf
├── modules/
│   ├── s3-backend/
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc/
│   │   ├── vpc.tf
│   │   ├── routes.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ecr/
│       ├── ecr.tf
│       ├── variables.tf
│       └── outputs.tf

## Commands
terraform init
terraform plan
terraform apply -auto-approve
# після створення backend.tf:
terraform init -migrate-state
terraform destroy

## Notes
- S3 для стейту: версіювання + шифрування, DynamoDB для блокування.
- VPC: 3 public + 3 private підмережі, IGW, 1 NAT, таблиці маршрутів.
- ECR: репозиторій зі scan-on-push та lifecycle policy (10 останніх образів).


## Commands

# 1) First run (local state)
terraform init
terraform plan
terraform apply -auto-approve

# 2) Enable remote backend after S3+DynamoDB exist:
#    - Update backend.tf with your unique bucket name and the region/table.
terraform init -migrate-state

# 3) Normal workflow
terraform plan
terraform apply

# 4) Destroy (remember: if this bucket is your backend, migrate back to local first)
#    a) mv backend.tf backend.tf.disabled && terraform init -reconfigure
#    b) terraform destroy -auto-approve

- S3 bucket sets `force_destroy = true`, so Terraform will empty the bucket (including object versions) during destroy.
