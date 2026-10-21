# Account A ID, read from the provider instead of hardcoding it
data "aws_caller_identity" "account_a" {
  provider = aws.account_a
}

# ---------- group1: CLI only ----------
# Users get access keys but no password, so they can't use the console

resource "aws_iam_group" "group1" {
  provider = aws.account_a
  name     = "group1"
}

resource "aws_iam_user" "engine" {
  provider = aws.account_a
  name     = "engine"
}

resource "aws_iam_user" "ci" {
  provider = aws.account_a
  name     = "ci"
}

resource "aws_iam_group_membership" "group1" {
  provider = aws.account_a
  name     = "group1-members"
  group    = aws_iam_group.group1.name
  users    = [aws_iam_user.engine.name, aws_iam_user.ci.name]
}

resource "aws_iam_access_key" "engine" {
  provider = aws.account_a
  user     = aws_iam_user.engine.name
}

resource "aws_iam_access_key" "ci" {
  provider = aws.account_a
  user     = aws_iam_user.ci.name
}

# ---------- group2: console + CLI ----------

resource "aws_iam_group" "group2" {
  provider = aws.account_a
  name     = "group2"
}

resource "aws_iam_user" "console_users" {
  provider = aws.account_a
  for_each = toset(var.console_users)
  name     = each.value
}

resource "aws_iam_group_membership" "group2" {
  provider = aws.account_a
  name     = "group2-members"
  group    = aws_iam_group.group2.name
  users    = [for u in aws_iam_user.console_users : u.name]
}

# Console password - must be changed on first login
resource "aws_iam_user_login_profile" "console_users" {
  provider                = aws.account_a
  for_each                = aws_iam_user.console_users
  user                    = each.value.name
  password_reset_required = true
}

# Access keys for CLI
resource "aws_iam_access_key" "console_users" {
  provider = aws.account_a
  for_each = aws_iam_user.console_users
  user     = each.value.name
}

resource "aws_iam_group_policy_attachment" "group2_admin" {
  provider   = aws.account_a
  group      = aws_iam_group.group2.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ---------- trust policy for roleA and roleB ----------
# Principals in Account A can assume these roles
# (they still need sts:AssumeRole in their own policy)

data "aws_iam_policy_document" "trust_account_a" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.account_a.account_id}:root"]
    }
  }
}

# ---------- roleA: admin except IAM ----------

resource "aws_iam_role" "roleA" {
  provider           = aws.account_a
  name               = "roleA"
  assume_role_policy = data.aws_iam_policy_document.trust_account_a.json
}

# NotAction = allow everything EXCEPT iam:*
data "aws_iam_policy_document" "roleA" {
  statement {
    effect      = "Allow"
    not_actions = ["iam:*"]
    resources   = ["*"]
  }
}

resource "aws_iam_role_policy" "roleA" {
  provider = aws.account_a
  name     = "admin-except-iam"
  role     = aws_iam_role.roleA.id
  policy   = data.aws_iam_policy_document.roleA.json
}

# ---------- roleB: can only assume roleC ----------

resource "aws_iam_role" "roleB" {
  provider           = aws.account_a
  name               = "roleB"
  assume_role_policy = data.aws_iam_policy_document.trust_account_a.json
}

data "aws_iam_policy_document" "roleB" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.roleC.arn]
  }
}

resource "aws_iam_role_policy" "roleB" {
  provider = aws.account_a
  name     = "assume-roleC-only"
  role     = aws_iam_role.roleB.id
  policy   = data.aws_iam_policy_document.roleB.json
}