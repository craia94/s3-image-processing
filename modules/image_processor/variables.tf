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
