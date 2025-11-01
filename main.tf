terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1" # обери свій регіон і використовуй його всюди
}

# === ВВЕДИ СВОЄ УНІКАЛЬНЕ ІМ'Я БАКЕТА ДЛЯ СТЕЙТУ ===
# Назва має бути глобально унікальною в S3 (наприклад: tf-state-iryna-lesson-5-euc1)
locals {
  state_bucket_name   = "tf-state-your-unique-name-euc1"
  dynamodb_table_name = "terraform-locks"
}

# S3 + DynamoDB для бекенду стейтів
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = local.state_bucket_name
  table_name  = local.dynamodb_table_name
}

# VPC (3 public + 3 private)
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-5-vpc"
}

# ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-5-ecr"
  scan_on_push = true
}
