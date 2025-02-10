terraform {
  backend "s3" {
    bucket         = "my-jenkins-eks-v1"
    region         = "us-east-1"
    key            = "DevSecOpEndtoEnd/Jenkins-Server-TF/terraform.tfstate"
    dynamodb_table = "my-jenkins-ddb-table"
    encrypt        = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}