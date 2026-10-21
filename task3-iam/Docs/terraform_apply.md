@pradeepsiriki ➜ /workspaces/DevOps-Tasks/task3-iam (main) $ terraform apply
╷
│ Warning: Deprecated Parameter
│ 
│ The parameter "dynamodb_table" is deprecated. Use parameter "use_lockfile" instead.
╵
data.aws_caller_identity.account_a: Reading...
data.aws_caller_identity.account_a: Read complete after 0s [id=379959319021]
data.aws_iam_policy_document.trust_account_a: Reading...
data.aws_iam_policy_document.roleA: Reading...
data.aws_iam_policy_document.roleA: Read complete after 0s [id=1803355327]
data.aws_iam_policy_document.trust_account_a: Read complete after 0s [id=2047694842]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.aws_iam_policy_document.roleB will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "roleB" {
      + id            = (known after apply)
      + json          = (known after apply)
      + minified_json = (known after apply)

      + statement {
          + actions   = [
              + "sts:AssumeRole",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
            ]
        }
    }

  # data.aws_iam_policy_document.roleC_s3 will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "roleC_s3" {
      + id            = (known after apply)
      + json          = (known after apply)
      + minified_json = (known after apply)

      + statement {
          + actions   = [
              + "s3:*",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
              + (known after apply),
            ]
        }
    }

  # data.aws_iam_policy_document.roleC_trust will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "roleC_trust" {
      + id            = (known after apply)
      + json          = (known after apply)
      + minified_json = (known after apply)

      + statement {
          + actions = [
              + "sts:AssumeRole",
            ]
          + effect  = "Allow"

          + principals {
              + identifiers = [
                  + (known after apply),
                ]
              + type        = "AWS"
            }
        }
    }

  # aws_iam_access_key.ci will be created
  + resource "aws_iam_access_key" "ci" {
      + create_date                    = (known after apply)
      + encrypted_secret               = (known after apply)
      + encrypted_ses_smtp_password_v4 = (known after apply)
      + id                             = (known after apply)
      + key_fingerprint                = (known after apply)
      + secret                         = (sensitive value)
      + ses_smtp_password_v4           = (sensitive value)
      + status                         = "Active"
      + user                           = "ci"
    }

  # aws_iam_access_key.console_users["alice"] will be created
  + resource "aws_iam_access_key" "console_users" {
      + create_date                    = (known after apply)
      + encrypted_secret               = (known after apply)
      + encrypted_ses_smtp_password_v4 = (known after apply)
      + id                             = (known after apply)
      + key_fingerprint                = (known after apply)
      + secret                         = (sensitive value)
      + ses_smtp_password_v4           = (sensitive value)
      + status                         = "Active"
      + user                           = "alice"
    }

  # aws_iam_access_key.console_users["bob"] will be created
  + resource "aws_iam_access_key" "console_users" {
      + create_date                    = (known after apply)
      + encrypted_secret               = (known after apply)
      + encrypted_ses_smtp_password_v4 = (known after apply)
      + id                             = (known after apply)
      + key_fingerprint                = (known after apply)
      + secret                         = (sensitive value)
      + ses_smtp_password_v4           = (sensitive value)
      + status                         = "Active"
      + user                           = "bob"
    }

  # aws_iam_access_key.engine will be created
  + resource "aws_iam_access_key" "engine" {
      + create_date                    = (known after apply)
      + encrypted_secret               = (known after apply)
      + encrypted_ses_smtp_password_v4 = (known after apply)
      + id                             = (known after apply)
      + key_fingerprint                = (known after apply)
      + secret                         = (sensitive value)
      + ses_smtp_password_v4           = (sensitive value)
      + status                         = "Active"
      + user                           = "engine"
    }

  # aws_iam_group.group1 will be created
  + resource "aws_iam_group" "group1" {
      + arn       = (known after apply)
      + id        = (known after apply)
      + name      = "group1"
      + path      = "/"
      + unique_id = (known after apply)
    }

  # aws_iam_group.group2 will be created
  + resource "aws_iam_group" "group2" {
      + arn       = (known after apply)
      + id        = (known after apply)
      + name      = "group2"
      + path      = "/"
      + unique_id = (known after apply)
    }

  # aws_iam_group_membership.group1 will be created
  + resource "aws_iam_group_membership" "group1" {
      + group = "group1"
      + id    = (known after apply)
      + name  = "group1-members"
      + users = [
          + "ci",
          + "engine",
        ]
    }

  # aws_iam_group_membership.group2 will be created
  + resource "aws_iam_group_membership" "group2" {
      + group = "group2"
      + id    = (known after apply)
      + name  = "group2-members"
      + users = [
          + "alice",
          + "bob",
        ]
    }

  # aws_iam_group_policy_attachment.group2_admin will be created
  + resource "aws_iam_group_policy_attachment" "group2_admin" {
      + group      = "group2"
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    }

  # aws_iam_role.roleA will be created
  + resource "aws_iam_role" "roleA" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS = "arn:aws:iam::379959319021:root"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "roleA"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # aws_iam_role.roleB will be created
  + resource "aws_iam_role" "roleB" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS = "arn:aws:iam::379959319021:root"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "roleB"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # aws_iam_role.roleC will be created
  + resource "aws_iam_role" "roleC" {
      + arn                   = (known after apply)
      + assume_role_policy    = (known after apply)
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "roleC"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # aws_iam_role_policy.roleA will be created
  + resource "aws_iam_role_policy" "roleA" {
      + id          = (known after apply)
      + name        = "admin-except-iam"
      + name_prefix = (known after apply)
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Effect    = "Allow"
                      + NotAction = "iam:*"
                      + Resource  = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role        = (known after apply)
    }

  # aws_iam_role_policy.roleB will be created
  + resource "aws_iam_role_policy" "roleB" {
      + id          = (known after apply)
      + name        = "assume-roleC-only"
      + name_prefix = (known after apply)
      + policy      = (known after apply)
      + role        = (known after apply)
    }

  # aws_iam_role_policy.roleC_s3 will be created
  + resource "aws_iam_role_policy" "roleC_s3" {
      + id          = (known after apply)
      + name        = "roleC-s3-access"
      + name_prefix = (known after apply)
      + policy      = (known after apply)
      + role        = (known after apply)
    }

  # aws_iam_user.ci will be created
  + resource "aws_iam_user" "ci" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "ci"
      + path          = "/"
      + tags_all      = (known after apply)
      + unique_id     = (known after apply)
    }

  # aws_iam_user.console_users["alice"] will be created
  + resource "aws_iam_user" "console_users" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "alice"
      + path          = "/"
      + tags_all      = (known after apply)
      + unique_id     = (known after apply)
    }

  # aws_iam_user.console_users["bob"] will be created
  + resource "aws_iam_user" "console_users" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "bob"
      + path          = "/"
      + tags_all      = (known after apply)
      + unique_id     = (known after apply)
    }

  # aws_iam_user.engine will be created
  + resource "aws_iam_user" "engine" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "engine"
      + path          = "/"
      + tags_all      = (known after apply)
      + unique_id     = (known after apply)
    }

  # aws_iam_user_login_profile.console_users["alice"] will be created
  + resource "aws_iam_user_login_profile" "console_users" {
      + encrypted_password      = (known after apply)
      + id                      = (known after apply)
      + key_fingerprint         = (known after apply)
      + password                = (sensitive value)
      + password_length         = 20
      + password_reset_required = true
      + user                    = "alice"
    }

  # aws_iam_user_login_profile.console_users["bob"] will be created
  + resource "aws_iam_user_login_profile" "console_users" {
      + encrypted_password      = (known after apply)
      + id                      = (known after apply)
      + key_fingerprint         = (known after apply)
      + password                = (sensitive value)
      + password_length         = 20
      + password_reset_required = true
      + user                    = "bob"
    }

  # aws_s3_bucket.data will be created
  + resource "aws_s3_bucket" "data" {
      + acceleration_status         = (known after apply)
      + acl                         = (known after apply)
      + arn                         = (known after apply)
      + bucket                      = "pradeep-accountb-data-379959319021"
      + bucket_domain_name          = (known after apply)
      + bucket_prefix               = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags_all                    = (known after apply)
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + cors_rule (known after apply)

      + grant (known after apply)

      + lifecycle_rule (known after apply)

      + logging (known after apply)

      + object_lock_configuration (known after apply)

      + replication_configuration (known after apply)

      + server_side_encryption_configuration (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

  # aws_s3_bucket_public_access_block.data will be created
  + resource "aws_s3_bucket_public_access_block" "data" {
      + block_public_acls       = true
      + block_public_policy     = true
      + bucket                  = (known after apply)
      + id                      = (known after apply)
      + ignore_public_acls      = true
      + restrict_public_buckets = true
    }

Plan: 23 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + ci_access_key          = (sensitive value)
  + console_user_passwords = (sensitive value)
  + engine_access_key      = (sensitive value)
  + roleA_arn              = (known after apply)
  + roleB_arn              = (known after apply)
  + roleC_arn              = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_s3_bucket.data: Creating...
aws_iam_user.console_users["bob"]: Creating...
aws_iam_user.console_users["alice"]: Creating...
aws_iam_group.group1: Creating...
aws_iam_group.group2: Creating...
aws_iam_user.ci: Creating...
aws_iam_user.engine: Creating...
aws_iam_role.roleB: Creating...
aws_iam_role.roleA: Creating...
aws_s3_bucket.data: Creation complete after 1s [id=pradeep-accountb-data-379959319021]
aws_s3_bucket_public_access_block.data: Creating...
data.aws_iam_policy_document.roleC_s3: Reading...
data.aws_iam_policy_document.roleC_s3: Read complete after 0s [id=3678958161]
aws_s3_bucket_public_access_block.data: Creation complete after 0s [id=pradeep-accountb-data-379959319021]
aws_iam_user.engine: Creation complete after 1s [id=engine]
aws_iam_access_key.engine: Creating...
aws_iam_user.ci: Creation complete after 1s [id=ci]
aws_iam_access_key.ci: Creating...
aws_iam_user.console_users["alice"]: Creation complete after 1s [id=alice]
aws_iam_user.console_users["bob"]: Creation complete after 1s [id=bob]
aws_iam_user_login_profile.console_users["bob"]: Creating...
aws_iam_access_key.console_users["alice"]: Creating...
aws_iam_access_key.console_users["bob"]: Creating...
aws_iam_user_login_profile.console_users["alice"]: Creating...
aws_iam_group.group1: Creation complete after 1s [id=group1]
aws_iam_group_membership.group1: Creating...
aws_iam_access_key.engine: Creation complete after 0s [id=AKIAVQ52XDHWR745FSLU]
aws_iam_access_key.ci: Creation complete after 0s [id=AKIAVQ52XDHW7WUIXYAQ]
aws_iam_group.group2: Creation complete after 1s [id=group2]
aws_iam_group_policy_attachment.group2_admin: Creating...
aws_iam_group_membership.group2: Creating...
aws_iam_access_key.console_users["bob"]: Creation complete after 0s [id=AKIAVQ52XDHW6G74CGVZ]
aws_iam_access_key.console_users["alice"]: Creation complete after 1s [id=AKIAVQ52XDHW6TZT2CRV]
aws_iam_role.roleA: Creation complete after 2s [id=roleA]
aws_iam_role_policy.roleA: Creating...
aws_iam_group_policy_attachment.group2_admin: Creation complete after 1s [id=group2-20261021110007653500000001]
aws_iam_user_login_profile.console_users["bob"]: Creation complete after 1s [id=bob]
aws_iam_role.roleB: Creation complete after 2s [id=roleB]
data.aws_iam_policy_document.roleC_trust: Reading...
data.aws_iam_policy_document.roleC_trust: Read complete after 0s [id=1114247462]
aws_iam_role.roleC: Creating...
aws_iam_group_membership.group1: Creation complete after 1s [id=group1-members]
aws_iam_user_login_profile.console_users["alice"]: Creation complete after 1s [id=alice]
aws_iam_group_membership.group2: Creation complete after 1s [id=group2-members]
aws_iam_role_policy.roleA: Creation complete after 0s [id=roleA:admin-except-iam]
aws_iam_role.roleC: Still creating... [00m10s elapsed]
aws_iam_role.roleC: Creation complete after 12s [id=roleC]
data.aws_iam_policy_document.roleB: Reading...
data.aws_iam_policy_document.roleB: Read complete after 0s [id=3933899869]
aws_iam_role_policy.roleC_s3: Creating...
aws_iam_role_policy.roleB: Creating...
aws_iam_role_policy.roleC_s3: Creation complete after 1s [id=roleC:roleC-s3-access]
aws_iam_role_policy.roleB: Creation complete after 1s [id=roleB:assume-roleC-only]

Apply complete! Resources: 23 added, 0 changed, 0 destroyed.

Outputs:

ci_access_key = <sensitive>
console_user_passwords = <sensitive>
engine_access_key = <sensitive>
roleA_arn = "arn:aws:iam::379959319021:role/roleA"
roleB_arn = "arn:aws:iam::379959319021:role/roleB"
roleC_arn = "arn:aws:iam::379959319021:role/roleC"