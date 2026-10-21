# ci user created in Task 3 - fails early if it doesn't exist
data "aws_iam_user" "ci" {
  user_name = "ci"
}

# Custom least privilege policy for the CI pipeline
resource "aws_iam_policy" "ci" {
  name        = "ci-pipeline-policy"
  description = "Push to one ECR repo, deploy one ECS service, read one S3 bucket"
  policy      = file("${path.module}/ci-policy.json")
}

resource "aws_iam_user_policy_attachment" "ci" {
  user       = data.aws_iam_user.ci.user_name
  policy_arn = aws_iam_policy.ci.arn
}

output "policy_arn" {
  value = aws_iam_policy.ci.arn
}