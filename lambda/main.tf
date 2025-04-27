# main.tf
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

variable "lambda_s3_key" {}
variable "lambda_role_arn" {}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my-lambda-func"
  s3_bucket     = "sandbox-test-lambda-code-bucket"
  s3_key        = var.lambda_s3_key
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = var.lambda_role_arn
  timeout       = 10
}
