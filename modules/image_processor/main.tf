data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "image_processor_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/image_processor.py"
  output_path = "${path.module}/lambda/image_processor.zip"
}

resource "aws_lambda_function" "image_processor_lambda" {
  filename      = data.archive_file.image_processor_lambda.output_path
  function_name = var.lambda_function_name
  role          = aws_iam_role.image_processor_lambda.arn
  handler       = "${var.lambda_function_name}.lambda_handler"
  runtime       = var.lambda_runtime
  layers        = concat(var.lambda_layer_arns, [])
}