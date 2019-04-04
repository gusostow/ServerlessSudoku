resource "aws_api_gateway_rest_api" "SudokuAPI" {
  name        = "SudokuAPI"
  description = "Terraform configured api"
}

resource "aws_api_gateway_resource" "sudoku" {
  rest_api_id = "${aws_api_gateway_rest_api.SudokuAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.SudokuAPI.root_resource_id}"
  path_part   = "sudoku"
}

resource "aws_api_gateway_method" "sudoku_post" {
    rest_api_id = "${aws_api_gateway_rest_api.SudokuAPI.id}"
    resource_id = "${aws_api_gateway_resource.sudoku.id}"
    http_method = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "sudoku_integration" {
    rest_api_id = "${aws_api_gateway_rest_api.SudokuAPI.id}"
    resource_id = "${aws_api_gateway_resource.sudoku.id}"
    http_method = "${aws_api_gateway_method.sudoku_post.http_method}"
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.sudoku_lambda.arn}/invocations"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.sudoku_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.SudokuAPI.execution_arn}/*/*/*"
}

resource "aws_api_gateway_deployment" "sudoku_deployment" {
  depends_on = ["aws_api_gateway_integration.sudoku_integration"]
  rest_api_id = "${aws_api_gateway_rest_api.SudokuAPI.id}"
  stage_name = "development"
  
}