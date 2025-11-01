terraform {
  backend "s3" {
    bucket         = "tf-state-your-unique-name-euc1"  # ← заміни на свою
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
