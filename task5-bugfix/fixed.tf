# Fixed version of the roleB -> roleC snippet.
# This runs in Account B (111111111111).

# FIX 1: roleB is a role, not a user. The principal must use ":role/".
data "aws_iam_policy_document" "roleC_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::000000000000:role/roleB"]
    }
  }
}

resource "aws_iam_role" "roleC" {
  name               = "roleC"
  assume_role_policy = data.aws_iam_policy_document.roleC_trust.json
}

# FIX 2: limit access to the one bucket instead of every bucket ("*").
resource "aws_iam_role_policy" "roleC_s3" {
  name = "roleC-s3-access"
  role = aws_iam_role.roleC.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "s3:*"
      Resource = [
        "arn:aws:s3:::pradeep-account-b-shared-bucket",
        "arn:aws:s3:::pradeep-account-b-shared-bucket/*"
      ]
    }]
  })
}
