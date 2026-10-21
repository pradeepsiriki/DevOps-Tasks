output "roleA_arn" {
  value = aws_iam_role.roleA.arn
}

output "roleB_arn" {
  value = aws_iam_role.roleB.arn
}

output "roleC_arn" {
  value = aws_iam_role.roleC.arn
}

# Secrets are marked sensitive so they don't print in the console.
# View them with: terraform output -json <name>
output "engine_access_key" {
  value     = { id = aws_iam_access_key.engine.id, secret = aws_iam_access_key.engine.secret }
  sensitive = true
}

output "ci_access_key" {
  value     = { id = aws_iam_access_key.ci.id, secret = aws_iam_access_key.ci.secret }
  sensitive = true
}

output "console_user_passwords" {
  value     = { for name, p in aws_iam_user_login_profile.console_users : name => p.password }
  sensitive = true
}
