terraform {
  backend "s3" {
    bucket       = "terraform-state-bucket-lesson-5"
    key          = "lesson-5/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
