resource "aws_route53_zone" "serverless_sudoku" {
    name = "${var.frontend_host}"
}

resource "aws_route53_record" "standard" {
    zone_id = "${aws_route53_zone.serverless_sudoku.zone_id}"
    name = "${var.frontend_host}"
    type = "A"
    
    alias = {
        name = "${aws_s3_bucket.frontend.website_endpoint}"
        zone_id = "${aws_s3_bucket.frontend.hosted_zone_id}"
        evaluate_target_health = true
    }
}