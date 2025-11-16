# Steps

Make sure you have installed `Terraform` and `Helm` on your system.

## Terraform

Initialize Terraform: 
```bash
terraform init
```

Check planned changes:
```bash
terraform plan
```

Apply changes:
```bash
terraform apply
```

## Docker

Make sure you are authenticated with AWS (aws ecr get-login)

Prepare the docker image locally (make sure you are located in the directory where Dockerfile is located):
(platform is used if working on MacOs which uses ARM)
```bash
docker build --platform linux/amd64 -t hello_image:latest .
```

To check if docker image exists locally:
```bash
docker images
```

Authenticate with AWS:
```bash
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 024937406982.dkr.ecr.eu-central-1.amazonaws.com
```

Upload the local existing Docker image to previously created ECR repository:
```bash
docker tag hello_image:latest 024937406982.dkr.ecr.eu-central-1.amazonaws.com/ecr-repo-18062025214500:latest
docker push 024937406982.dkr.ecr.eu-central-1.amazonaws.com/ecr-repo-18062025214500:latest
```

## Helm

Apply helm chart:
```bash
cd charts/django-app
helm install my-django .
```

where `my-django` is your helm chart name.

## Deleting resources:

Kubernetes (PODs, Services, Deployments etc.)
```bash
helm uninstall my-django
```

where `my-django` is your helm chart name.

Terraform (EKS, VPC, ECR etc.)
```bash
terraform destroy
```

# Additional information

If you want to update the Helm chart:
```bash
helm upgrade my-django .
```

If you want to update Terraform:
```bash
terraform init -upgrade
terraform plan
terraform apply
```

# Description of Terraform Modules

## s3-backend

A module for creating an S3 bucket to store Terraform state files. The module sets up:

* S3 bucket
* Versioning and ownership control
* DynamoDB table for state file locking

## vpc

A module for creating a VPC. The module configures:

* VPC with public and private subnets
* Availability zones
* NAT Gateway, Internet Gateway
* Route tables for internet access

## ecr

A module for creating an ECR repository. The module:

* Creates an Amazon ECR repository
* Enables automatic security vulnerability scanning on image push

## eks

A module for creating an EKS cluster. The module:

* Creates an Amazon EKS cluster
* Enables automatic security vulnerability scanning during image push
