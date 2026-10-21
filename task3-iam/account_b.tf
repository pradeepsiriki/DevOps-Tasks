# The single bucket roleC can access
resource "aws_s3_bucket" "data" {
  provider = aws.account_b
  bucket   = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "data" {
  provider = aws.account_b
  bucket   = aws_s3_bucket.data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------- roleC ----------

# Trust ONLY roleB's ARN - not the whole Account A
data "aws_iam_policy_document" "roleC_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.roleB.arn]
    }
  }
}

resource "aws_iam_role" "roleC" {
  provider           = aws.account_b
  name               = "roleC"
  assume_role_policy = data.aws_iam_policy_document.roleC_trust.json
}

# Full S3 access, but only on this one bucket
# bucket ARN = bucket actions (list), bucket/* = object actions (get/put)
data "aws_iam_policy_document" "roleC_s3" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.data.arn,
      "${aws_s3_bucket.data.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "roleC_s3" {
  provider = aws.account_b
  name     = "roleC-s3-access"
  role     = aws_iam_role.roleC.id
  policy   = data.aws_iam_policy_document.roleC_s3.json
}