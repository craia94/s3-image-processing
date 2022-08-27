# Role for image processor lambda
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

# Policy for lambda permissions
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
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:CopyObject",
                "s3:HeadObject",
                "s3:DeleteObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${local.pre_process_bucket_name}",
                "arn:aws:s3:::${local.pre_process_bucket_name}/*"
            ]
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:CopyObject",
                "s3:HeadObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${local.post_process_bucket_name}",
                "arn:aws:s3:::${local.post_process_bucket_name}/*"
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