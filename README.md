# DevOps Assignment - Terraform on AWS

```
task1-ec2/            5 EC2 instances from one variable (module in modules/ec2)
task2-remote-state/   S3 bucket + DynamoDB table for remote state
task3-iam/            IAM groups, users and roles across Account A and B
task4-ci-policy/      Least privilege policy for the ci user
task5-bugfix/         Fixed roleB -> roleC snippet
NOTES.md              Explanations and answers for all tasks
```

## How to run

1. Create the state bucket and lock table first:
   ```
   cd task2-remote-state
   terraform init
   terraform apply
   ```
2. Create the EC2 instances (key pairs must already exist in the region):
   ```
   cd task1-ec2
   terraform init
   terraform plan
   terraform apply
   ```
3. IAM across both accounts (needs a `TerraformDeployRole` in each account):
   ```
   cd task3-iam
   terraform init
   terraform apply
   ```
4. CI policy (after task 3, since it attaches to the `ci` user):
   ```
   cd task4-ci-policy
   terraform init
   terraform apply
   ```

All explanations are in [NOTES.md](NOTES.md).
