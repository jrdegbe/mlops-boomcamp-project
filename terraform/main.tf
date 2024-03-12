terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
    }
  }

  # Make sure to create state bucket before.
  backend "s3" {
    bucket  = "tf-state-mlops"
    key     = "mlops-stg.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}

provider "aws" {
  profile                  = "default"
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
}

data "aws_caller_identity" "current_identity" {}

locals {
  account_id = data.aws_caller_identity.current_identity.account_id
}

module "ec2_module" {
  source = "./modules/ec2"
}









/*
# Create an IAM policy.
# See https://devopscube.com/terraform-iam-role/
resource "aws_iam_policy" "boomcamp_iam_policy" {
    name = var.iam_policy_name
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "iam:CreatePolicy",
                    "iam:CreateRole",
                    "iam:PutRolePolicy",
                    "iam:AttachRolePolicy",
                    "iam:DetachRolePolicy",
                    "ec2:RunInstances",
                    "iam:PassRole",
                ]
                Resource = "arn:aws:iam::225225188738:role/Get-pics"
            }
        ]
    })
}

# Create an IAM role.
# See https://devopscube.com/terraform-iam-role/
resource "aws_iam_role" "boomcamp_role" {
    name = var.role_name
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

# Attach the IAM policy to the IAM role.
# # See https://devopscube.com/terraform-iam-role/
resource "aws_iam_policy_attachment" "boomcamp_role_policy_attachment" {
    name = "Policy Attachement"
    roles      = [aws_iam_role.boomcamp_role.name]
    policy_arn = aws_iam_policy.boomcamp_iam_policy.arn
}

# Create an IAM instance profile.
# See https://devopscube.com/terraform-iam-role/
resource "aws_iam_instance_profile" "boomcamp_instance_profile" {
    name = var.instance_profile_name
    role = aws_iam_role.boomcamp_role.name
}
*/



/*
# ride_events
module "source_kinesis_stream" {
  source = "./modules/kinesis"
  retention_period = 48
  shard_count = 2
  stream_name = "${var.source_stream_name}-${var.project_id}"
  tags = var.project_id
}

# ride_predictions
module "output_kinesis_stream" {
  source = "./modules/kinesis"
  retention_period = 48
  shard_count = 2
  stream_name = "${var.output_stream_name}-${var.project_id}"
  tags = var.project_id
}
*/

/*
# model bucket
module "s3_bucket" {
  source = "./modules/s3"
  bucket_name = "${var.model_bucket}-${var.project_id}"
}
*/

/*
# image registry
module "ecr_image" {
   source = "./modules/ecr"
   ecr_repo_name = "${var.ecr_repo_name}_${var.project_id}"
   account_id = local.account_id
   lambda_function_local_path = var.lambda_function_local_path
   docker_image_local_path = var.docker_image_local_path
}

module "lambda_function" {
  source = "./modules/lambda"
  image_uri = module.ecr_image.image_uri
  lambda_function_name = "${var.lambda_function_name}_${var.project_id}"
  model_bucket = module.s3_bucket.name
  output_stream_name = "${var.output_stream_name}-${var.project_id}"
  output_stream_arn = module.output_kinesis_stream.stream_arn
  source_stream_name = "${var.source_stream_name}-${var.project_id}"
  source_stream_arn = module.source_kinesis_stream.stream_arn
}

# For CI/CD
output "lambda_function" {
  value = "${var.lambda_function_name}_${var.project_id}"
}
*/

/*
output "model_bucket" {
  value = module.s3_bucket.name
}
*/

/*
output "predictions_stream_name" {
  value = "${var.output_stream_name}-${var.project_id}"
}

output "ecr_repo" {
  value = "${var.ecr_repo_name}_${var.project_id}"
}
*/