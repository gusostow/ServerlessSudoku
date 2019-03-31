resource "aws_s3_bucket" "frontend" {
    bucket = "${var.frontend_host}"
    acl = "public-read"
    force_destroy = true
    
    logging {
        target_bucket = "${aws_s3_bucket.logs.bucket}"
        target_prefix = "${var.frontend_host}/"
    }

    website {
        index_document = "index.html"
    }
}

resource "aws_s3_bucket_policy" "frontend_policy" {
    depends_on = ["aws_s3_bucket.frontend"]

    bucket = "${aws_s3_bucket.frontend.id}"
    policy = <<EOF
{
"Id": "Policy1553801441284",
"Version": "2012-10-17",
"Statement": [
{
    "Sid": "Stmt1553801425433",
    "Action": [
    "s3:GetObject"
    ],
    "Effect": "Allow",
    "Resource": "arn:aws:s3:::${aws_s3_bucket.frontend.bucket}/*",
    "Principal": {
        "AWS": "*"
    }
}
]
}
EOF
}

resource "null_resource" "sync_static" {
    depends_on = ["aws_s3_bucket.frontend"]
    triggers = {
        # TODO: Figure out how to hash static folder
        lambda_payload_hash = "${md5(file(var.source_code_path))}"
    }
    
    provisioner "local-exec" {
        command = "aws s3 sync ../static s3://${aws_s3_bucket.frontend.bucket}"
    }
}

resource "aws_s3_bucket" "logs" {
    bucket = "${var.frontend_host}-logs"
    acl = "log-delivery-write"
    force_destroy = true
}