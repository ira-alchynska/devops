resource "aws_ecr_repository" "this" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = var.scan_on_push }

  encryption_configuration { encryption_type = "AES256" }

  tags = { Name = var.ecr_name }
}

# Політика доступу (для прикладу — дозволити акаунту читати/писати)
data "aws_caller_identity" "current" {}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.this.name
  policy     = jsonencode({
    Version = "2008-10-17",
    Statement = [{
      Sid = "AllowAccountPushPull",
      Effect = "Allow",
      Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
      Action = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeRepositories",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
        "ecr:DeleteRepositoryPolicy"
      ]
    }]
  })
}

# Опційно: політика життєвого циклу — лишати 10 останніх образів
resource "aws_ecr_lifecycle_policy" "keep_last_10" {
  repository = aws_ecr_repository.this.name
  policy     = jsonencode({
    rules = [{
      rulePriority = 1,
      description  = "Keep last 10 images",
      selection = {
        tagStatus   = "any",
        countType   = "imageCountMoreThan",
        countNumber = 10
      },
      action = { type = "expire" }
    }]
  })
}
