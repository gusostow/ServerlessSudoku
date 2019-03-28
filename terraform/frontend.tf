resource "aws_s3_bucket" "frontend" {
    bucket = "${var.frontend_host}"
    acl = "public-read"
    
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

resource "aws_s3_bucket_object" "index" {
    bucket = "${aws_s3_bucket.frontend.bucket}"
    key = "index.html"
    source = "${var.index_file}"
    etag = "${md5(file(var.index_file))}"
}

resource "aws_s3_bucket" "logs" {
    bucket = "${var.frontend_host}-logs"
    acl = "log-delivery-write"
}