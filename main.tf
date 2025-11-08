provider "aws" {
  region = "eu-central-1"
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-lesson-5"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-5-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-5-ecr"
  scan_on_push = true
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = "lesson-7-eks-new"
  node_group_name    = "lesson-7-eks-new-nodes"

  # from your VPC module outputs
  # from your VPC module outputs (public_subnets and private_subnets are the correct output names)
  public_subnet_ids  = module.vpc.public_subnets
  subnet_ids         = concat(module.vpc.public_subnets, module.vpc.private_subnets)

  # single instance type expected by module
  instance_type      = "t3.micro"

  desired_size       = 2
  min_size           = 1
  max_size           = 2

}