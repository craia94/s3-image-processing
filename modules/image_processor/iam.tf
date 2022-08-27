resource "aws_iam_role" "image_processor_lambda" {
  name = "image-processor-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "image_processor_lambda" {
  name        = "image-processor-lambda"
  path        = "/"
  description = "Permissons for image_processor_lambda"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "image_processor_lambda" {
  role       = aws_iam_role.image_processor_lambda.name
  policy_arn = aws_iam_policy.image_processor_lambda.arn
}