terraform {
  backend "s3" {
    bucket         = "mk1-tfstate-vpa"   # <-- YOUR bucket name
    key            = "mk1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
