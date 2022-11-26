terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

/* Bucket to save lambda code */
resource "random_id" "bucket_name" {
  byte_length = 8
}

resource "aws_s3_bucket" "code_bucket" {
  bucket = random_id.bucket_name.hex
}

resource "aws_s3_object" "lambda_code" {
  bucket      = aws_s3_bucket.code_bucket.id
  key         = var.jar_file
  source      = "../target/${var.jar_file}"
  source_hash = filemd5("../target/${var.jar_file}")
}

/* Lambda function role */
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    })
}

/* Lambda function */
resource "aws_lambda_function" "test_lambda" {
  function_name = "java-basic"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.application_handler
  memory_size   = 512
  timeout       = 10
  runtime       = "java8"

  # code in local machine
  # filename         = "../target/java-basic-1.0-SNAPSHOT.jar"
  # source_code_hash = filebase64sha256("../target/java-basic-1.0-SNAPSHOT.jar")

  # code in s3 bucket
  s3_bucket        = aws_s3_bucket.code_bucket.id
  s3_key           = aws_s3_object.lambda_code.key
  source_code_hash = aws_s3_object.lambda_code.source_hash
}