# CI/CD Pipeline with Jenkins, Argo CD, Helm, and Terraform

This project implements a complete CI/CD pipeline for a Django application on AWS using:
- **Jenkins** - CI server with Kubernetes agents (Kaniko + Git)
- **Argo CD** - GitOps continuous delivery tool
- **Helm** - Kubernetes package manager
- **Terraform** - Infrastructure as Code
- **Amazon EKS** - Managed Kubernetes service
- **Amazon ECR** - Docker container registry

## Prerequisites

Make sure you have installed the following on your system:
- `Terraform` (>= 1.0)
- `Helm` (>= 3.0)
- `kubectl`
- `aws-cli` configured with appropriate credentials
- Docker (for local testing)

## Initial Setup

### 1. Configure Terraform Variables

Copy the example variables file and fill in your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your configuration:

```hcl
# AWS Configuration
region = "your-region"
cluster_name = "your-cluster-name"
vpc_name = "your-vpc-name"
instance_type = "t2.medium"
repository_name = "your-repo-name"

# GitHub Configuration
github_user = "your-github-username"
github_pat = "your-github-personal-access-token"
github_repo_url = "https://github.com/your-username/your-repo"
```

**Important:** 
- Create a GitHub Personal Access Token with `repo` (full control) permissions
- The token is stored in `terraform.tfvars` which is gitignored for security

### 2. Initialize and Apply Terraform

Initialize Terraform:

```bash
terraform init
```

Review the planned changes:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

This will create:
- VPC with public/private subnets
- EKS cluster
- ECR repository
- Jenkins (installed via Helm)
- Argo CD (installed via Helm)
- All necessary IAM roles and policies

### 3. Configure kubectl

After Terraform completes, configure kubectl to connect to your EKS cluster:

```bash
aws eks update-kubeconfig --region <your-region> --name <your-cluster-name>
```

Verify connection:

```bash
kubectl get nodes
```

## Accessing Jenkins

### Get Jenkins URL and Credentials

Jenkins is accessible via LoadBalancer. Get the URL:

```bash
kubectl get svc -n jenkins jenkins -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Get the password from Kubernetes secret:

```bash
kubectl get secret -n jenkins jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d && echo
```

Default credentials:
- **Username:** `admin`
- **Password:** (from command above)

### Jenkins Setup

1. Access Jenkins UI with previous received URL
2. Login with admin credentials
3. The `seed-job` should already be created
4. Run the `seed-job` to create the `goit-django-docker` pipeline
5. Approve any pending script approvals if prompted:
   - Go to: **Manage Jenkins** → **In-process Script Approval**
   - Approve the pending script

## Accessing Argo CD

### Get Argo CD URL and Credentials

Argo CD is accessible via LoadBalancer. Get the URL:

```bash
kubectl get svc -n argocd argo-cd-argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Get the admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

Default credentials:
- **Username:** `admin`
- **Password:** (from command above)

Access Argo CD UI with previous received URL.

## CI/CD Pipeline Workflow

### Pipeline Overview

The `goit-django-docker` pipeline in Jenkins:

1. **Build & Push Docker Image**
   - Uses Kaniko to build Docker image from `app/Dockerfile`
   - Pushes image to ECR with tag `v1.0.{BUILD_NUMBER}`

2. **Update Chart Tag in Git**
   - Clones the repository
   - Checks out `main` branch
   - Updates `charts/django-app/values.yaml` with new image tag
   - Commits and pushes changes to `main` branch

### Running the Pipeline

1. In Jenkins UI, go to **goit-django-docker** job
2. Click **Build Now**
3. Monitor the build progress
4. After completion, check:
   - ECR repository for the new image
   - Git repository `main` branch for updated `values.yaml`
   - Argo CD UI for automatic sync

### Argo CD Auto-Sync

Argo CD is configured to:
- Monitor `charts/django-app` in the `main` branch
- Automatically sync when `values.yaml` changes
- Deploy the new Docker image to Kubernetes cluster

The application `django-app` should appear in Argo CD UI and automatically sync after Jenkins updates the Helm chart.

## Project Structure

```
.
├── main.tf                 # Main Terraform configuration
├── backend.tf              # Terraform backend (S3 + DynamoDB)
├── variables.tf            # Terraform variables
├── outputs.tf              # Terraform outputs
├── terraform.tfvars        # Your variable values (gitignored)
├── Jenkinsfile             # CI/CD pipeline definition
├── modules/                # Terraform modules
│   ├── s3-backend/         # S3 and DynamoDB for state
│   ├── vpc/                # VPC, subnets, gateways
│   ├── ecr/                # ECR repository
│   ├── eks/                # EKS cluster
│   ├── jenkins/            # Jenkins Helm installation
│   └── argo_cd/            # Argo CD Helm installation
├── charts/
│   └── django-app/         # Helm chart for Django app
└── app/                    # Django application source
```

## Manual Operations

### Update Helm Chart Manually

If you need to update the Helm chart manually:

```bash
cd charts/django-app
helm upgrade my-django .
```

### Update Terraform

To update Terraform configuration:

```bash
terraform init -upgrade
terraform plan
terraform apply
```

### View Jenkins Logs

```bash
kubectl logs -n jenkins jenkins-0 -c jenkins
```

### View Argo CD Application Status

```bash
kubectl get applications -n argocd
kubectl get application django-app -n argocd -o yaml
```

## Cleanup

### Remove Kubernetes Resources

Uninstall Helm releases:

```bash
helm uninstall my-django
helm uninstall jenkins -n jenkins
helm uninstall argo-cd -n argocd
```

### Destroy Terraform Resources

**Warning:** This will delete all AWS resources (EKS, VPC, ECR, etc.)

```bash
terraform destroy
```

## Troubleshooting

### Jenkins Pipeline Issues

- **Environment variables null:** Check that global environment variables are configured in Jenkins
- **Script approval needed:** Approve scripts in **Manage Jenkins** → **In-process Script Approval**
- **Build context errors:** Ensure Dockerfile and requirements.txt are in `app/` directory

### Argo CD Sync Issues

- **Application not syncing:** Check that `targetRevision` is set to `main` branch
- **Repository access denied:** Verify GitHub PAT has correct permissions
- **Application status Unknown:** Check Argo CD logs: `kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller`

### EKS Connection Issues

```bash
# Update kubeconfig
aws eks update-kubeconfig --region <region> --name <cluster-name>

# Verify connection
kubectl get nodes
```

## Module Descriptions

### s3-backend
Creates S3 bucket for Terraform state storage and DynamoDB table for state locking.

### vpc
Creates VPC with public and private subnets across multiple availability zones, including NAT Gateway and Internet Gateway.

### ecr
Creates ECR repository with automatic image scanning enabled.

### eks
Creates EKS cluster with node groups, OIDC provider, and EBS CSI driver.

### jenkins
Installs Jenkins via Helm with:
- Kubernetes plugin for agent pods
- Kaniko and Git containers for builds
- IAM role for ECR access
- GitHub credentials configuration

### argo_cd
Installs Argo CD via Helm with:
- Application monitoring `charts/django-app`
- Auto-sync enabled
- GitHub repository integration

## Additional Notes

- The pipeline pushes to `main` branch by default
- Image tags follow pattern: `v1.0.{BUILD_NUMBER}`
- Argo CD monitors the `main` branch for changes
- All sensitive data (tokens, passwords) should be in `terraform.tfvars` (gitignored)
