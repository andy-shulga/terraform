
resource "aws_lambda_function" "my_lambda" {
  function_name = "example_lambda_function"
  handler      = "lambda_function.handler"
  runtime      = "python3.10"
  timeout      = 10
  memory_size  = 128

  # Replace with your own Lambda function code
  filename      = "lambda_func.zip"
  source_code_hash = filebase64sha256("lambda_func.zip")

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      EXAMPLE_ENV_VAR = "example_value"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "example_lambda_role"

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

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}