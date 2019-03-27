resource "aws_lambda_function" "sudoku_lambda" {
  function_name    = "sudoku_handler"
  handler          = "lambda.handler"
  runtime          = "python3.7"
  filename         = "${var.source_code_path}"
  source_code_hash = "${base64sha256(file("${var.source_code_path}"))}"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
}
