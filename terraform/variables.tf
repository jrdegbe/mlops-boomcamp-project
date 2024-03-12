variable "aws_region" {
  type        = string
  description = "AWS region to create resources"
  default     = "eu-north-1"
}

variable "project_id" {
  type        = string
  description = "project_id"
  default     = "mlops-boomcamp"
}

variable "model_bucket" {
  description = "s3_bucket"
  default     = "mlflow-models-code-owners"
}

/*
variable "subnet_id" {
    description = "The VPC subnet the instance(s) will be created in"
    default = "subnet-07ebbe60"
}
*/

/*
variable "number_of_instances" {
    description = "Number of instances to be created"
    default = 1
}
*/

/*
variable "ami_key_pair_name" {
    default = "tomcat"
}
*/


/*
variable "source_stream_name" {
  description = ""
}

variable "output_stream_name" {
  description = ""
}
*/

/*
variable "lambda_function_local_path" {
  description = ""
}

variable "docker_image_local_path" {
  description = ""
}

variable "ecr_repo_name" {
  description = ""
}

variable "lambda_function_name" {
  description = ""
}
*/