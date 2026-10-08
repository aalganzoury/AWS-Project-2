# Remote state placeholders — fill with YOUR bucket/table (never commit real values).
terraform {
  backend "s3" {
    bucket         = "PLACEHOLDER-tfstate-111111111111"
    key            = "week1-core/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "PLACEHOLDER-tflock"
    encrypt        = true
  }
}
