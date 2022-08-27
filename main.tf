# Module for image processor lambda
# module "image_processor" {
#   source               = "./modules/image_processor"
#   lambda_function_name = var.service_now_mi_lambda_function_name
#   lambda_runtime       = var.service_now_mi_lambda_runtime
#   lambda_layer_arns    = concat(var.service_now_mi_lambda_layer_arns, [var.python_requests_lambda_layer_arn])
# }

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "image_processor_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/image_processor.py"
  output_path = "${path.module}/lambda/image_processor.zip"
}

# Lambda for image processor
resource "aws_lambda_function" "image_processor_lambda" {
  filename      = data.archive_file.image_processor_lambda.output_path
  function_name = var.lambda_function_name
  role          = aws_iam_role.image_processor_lambda.arn
  handler       = "${var.lambda_function_name}.lambda_handler"
  runtime       = var.lambda_runtime
  layers        = concat(var.lambda_layer_arns, [])
  environment {
    variables = {
      POST_PROCESSING_BUCKET_NAME = aws_s3_bucket.post_process_bucket.id
    }
  }
}

# Pre processed bucket
resource "aws_s3_bucket" "pre_process_bucket" {
  bucket = local.pre_process_bucket_name
}

# Allow S3 to invoke lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.pre_process_bucket.arn
}

# Trigger for lambda
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.pre_process_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = "images/"
    filter_suffix       = ".jpg"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

# Post processed bucket
resource "aws_s3_bucket" "post_process_bucket" {
  bucket = local.post_process_bucket_name
}
