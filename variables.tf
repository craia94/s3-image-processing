variable "region" {
  description = "Region to deploy resources"
  type = string
}

variable "lambda_function_name" {
  default     = "image_processor"
  description = "Unique name for Lambda Function"
  type        = string
}

variable "lambda_layer_arns" {
  default     = []
  description = "List of Lambda Layer arns to attach to the lambda function"
  type        = list(string)
}

variable "lambda_runtime" {
  default     = "python3.9"
  description = "Python identifier of the function's runtime"
  type        = string
}

variable "pre_process_bucket_name" {
  description = "value"
  type = string
}

variable "post_process_bucket_name" {
  description = "value"
  type = string
}

variable "s3_notification_file_suffix" {
  default = ".jpg"
  description = "Suffix of files that should trigger the S3 notification"
  type = string
}

variable "user_a_name" {
  default = "user_a"
  description = "Users name"
}

variable "user_a_path" {
  default = "/system/"
  description = "Path to create the user"
}

variable "user_b_name" {
  default = "user_b"
  description = "Users name"
}

variable "user_b_path" {
  default = "/system/"
  description = "Path to create the user"
}

variable "pgp_key_path" {
  default = "public-key-binary.gpg"
  description = "Path to file for pgp key used to encrypt iam access keys. Path is relative to root of terraform directory"
}

locals {
  pre_process_bucket_name = "${data.aws_caller_identity.current.account_id}-${var.pre_process_bucket_name}"
  post_process_bucket_name = "${data.aws_caller_identity.current.account_id}-${var.post_process_bucket_name}"
}