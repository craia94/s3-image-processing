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

locals {
  pre_process_bucket_name = "${data.aws_caller_identity.current.account_id}-${var.pre_process_bucket_name}"
  post_process_bucket_name = "${data.aws_caller_identity.current.account_id}-${var.post_process_bucket_name}"
}