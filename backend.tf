# Розкоментуйте, щоб підключити бекенд до Terraform

# Temporarily commented out - S3 backend bucket was deleted
# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket-18062025214500-ira"  # Назва S3-бакета
#     key            = "terraform.tfstate"                        # Шлях до файлу стейту
#     region         = "eu-central-1"                             # Регіон AWS
#     dynamodb_table = "terraform-locks"                          # Назва таблиці DynamoDB
#     encrypt        = true                                       # Шифрування файлу стейту
#   }
# }