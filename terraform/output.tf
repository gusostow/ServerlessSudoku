output "source_code_path" {value = "${var.source_code_path}"}

output "api_url" {value = "${aws_api_gateway_deployment.sudoku_deployment.invoke_url}"}

output "frontend_url" {value = "${aws_s3_bucket.frontend.website_endpoint}"}