terraform apply
╷
│ Warning: Deprecated Parameter
│ 
│ The parameter "dynamodb_table" is deprecated. Use parameter "use_lockfile" instead.
╵
data.aws_iam_user.ci: Reading...
data.aws_iam_user.ci: Read complete after 1s [id=AIDAVQ52XDHWQNGD6ZNBQ]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_iam_policy.ci will be created
  + resource "aws_iam_policy" "ci" {
      + arn              = (known after apply)
      + attachment_count = (known after apply)
      + description      = "Push to one ECR repo, deploy one ECS service, read one S3 bucket"
      + id               = (known after apply)
      + name             = "ci-pipeline-policy"
      + name_prefix      = (known after apply)
      + path             = "/"
      + policy           = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = "ecr:GetAuthorizationToken"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "EcrLogin"
                    },
                  + {
                      + Action   = [
                          + "ecr:BatchCheckLayerAvailability",
                          + "ecr:InitiateLayerUpload",
                          + "ecr:UploadLayerPart",
                          + "ecr:CompleteLayerUpload",
                          + "ecr:PutImage",
                        ]
                      + Effect   = "Allow"
                      + Resource = "arn:aws:ecr:ap-south-1:379959319021:repository/my-app"
                      + Sid      = "EcrPushToOneRepo"
                    },
                  + {
                      + Action   = [
                          + "ecs:RegisterTaskDefinition",
                          + "ecs:DescribeTaskDefinition",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "EcsRegisterTaskDefinition"
                    },
                  + {
                      + Action   = [
                          + "ecs:UpdateService",
                          + "ecs:DescribeServices",
                        ]
                      + Effect   = "Allow"
                      + Resource = "arn:aws:ecs:ap-south-1:379959319021:service/my-cluster/my-app-service"
                      + Sid      = "EcsUpdateOneService"
                    },
                  + {
                      + Action    = "iam:PassRole"
                      + Condition = {
                          + StringEquals = {
                              + "iam:PassedToService" = "ecs-tasks.amazonaws.com"
                            }
                        }
                      + Effect    = "Allow"
                      + Resource  = [
                          + "arn:aws:iam::379959319021:role/my-app-task-execution-role",
                          + "arn:aws:iam::379959319021:role/my-app-task-role",
                        ]
                      + Sid       = "PassOnlyTheTaskRoles"
                    },
                  + {
                      + Action   = "s3:ListBucket"
                      + Effect   = "Allow"
                      + Resource = "arn:aws:s3:::my-build-artifacts"
                      + Sid      = "ListArtifactBucket"
                    },
                  + {
                      + Action   = "s3:GetObject"
                      + Effect   = "Allow"
                      + Resource = "arn:aws:s3:::my-build-artifacts/*"
                      + Sid      = "ReadArtifacts"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id        = (known after apply)
      + tags_all         = (known after apply)
    }

  # aws_iam_user_policy_attachment.ci will be created
  + resource "aws_iam_user_policy_attachment" "ci" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + user       = "ci"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + policy_arn = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_iam_policy.ci: Creating...
aws_iam_policy.ci: Creation complete after 1s [id=arn:aws:iam::379959319021:policy/ci-pipeline-policy]
aws_iam_user_policy_attachment.ci: Creating...
aws_iam_user_policy_attachment.ci: Creation complete after 1s [id=ci-20261021120321368600000001]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

policy_arn = "arn:aws:iam::379959319021:policy/ci-pipeline-policy"
@pradeepsiriki ➜ /workspaces/DevOps-Tasks/task4-ci-policy (main) $ aws iam list-attached-user-policies --user-name ci --output table
---------------------------------------------------------------------------------
|                           ListAttachedUserPolicies                            |
+-------------------------------------------------------------------------------+
||                              AttachedPolicies                               ||
|+------------------------------------------------------+----------------------+|
||                       PolicyArn                      |     PolicyName       ||
|+------------------------------------------------------+----------------------+|
||  arn:aws:iam::379959319021:policy/ci-pipeline-policy |  ci-pipeline-policy  ||
|+------------------------------------------------------+----------------------+|
@pradeepsiriki ➜ /workspaces/DevOps-Tasks/task4-ci-policy (main) $ 