# How to Test

How I test all 5 tasks from start to finish. The tasks depend on each other, so the order matters:

- Task 1 stores its state in the bucket from Task 2, so Task 2 is created first.
- Task 4 attaches a policy to the ci user from Task 3.
- The Task 5 test uses roleB from Task 3.

Everything runs from the repo root in GitHub Codespaces, region ap-south-1 (Mumbai).


## 0. Before starting

Check the AWS login. The ARN must end with user/terraform-admin, not root. Root can't assume roles, so the Task 3 tests would fail.

```bash
aws sts get-caller-identity
terraform version
```

Check the 5 key pairs exist:

```bash
aws ec2 describe-key-pairs --region ap-south-1 --query 'KeyPairs[].KeyName'
```

If they are missing, create them:

```bash
mkdir -p ~/keys
for k in key-web key-app key-db key-cache key-bastion; do
  aws ec2 create-key-pair --region ap-south-1 --key-name $k --query 'KeyMaterial' --output text > ~/keys/$k.pem
  chmod 400 ~/keys/$k.pem
done
```


## 1. Task 2 - create the state bucket and lock table

```bash
cd task2-remote-state
terraform init
terraform apply
cd ..
```

Expected: 5 resources created. Check:

```bash
aws s3 ls | grep tfstate
aws dynamodb describe-table --table-name terraform-state-lock --region ap-south-1 --query 'Table.TableStatus'
```

Expected: the bucket name and "ACTIVE".


## 2. Task 1 - EC2 instances

My account is on the Free plan, which blocks io1 and io2. For the test run only, in task1-ec2/main.tf change db-server and cache-server to volume_type = "gp3" and comment out their iops lines. Don't commit this change.

```bash
cd task1-ec2
terraform init
terraform plan
terraform apply
```

Expected: 5 to add, then the outputs instance_ids and private_ips with all 5 names.

Check instance types, key pairs and tags:

```bash
aws ec2 describe-instances --region ap-south-1 \
  --filters Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`]|[0].Value, Type:InstanceType, Key:KeyName, Env:Tags[?Key==`Environment`]|[0].Value, Owner:Tags[?Key==`Owner`]|[0].Value}' \
  --output table
```

Expected: 5 rows, each with a different type and key, and every row has Env and Owner.

Check volume types and sizes:

```bash
aws ec2 describe-volumes --region ap-south-1 \
  --filters Name=attachment.device,Values=/dev/xvda \
  --query 'Volumes[].{Instance:Attachments[0].InstanceId, Type:VolumeType, Size:Size}' \
  --output table
```

Check the outputs:

```bash
terraform output
```

Check the lifecycle protection on db-server:

```bash
terraform plan -destroy
```

Expected: it fails with "Instance cannot be destroyed" for db-server. Nothing is deleted.

In the console: EC2 > Instances (Mumbai region). Use the gear icon to show the Instance type, Key pair name and the Environment and Owner tag columns.


## 3. Task 2 - check remote state and locking

Still in task1-ec2. Check the state file is in S3:

```bash
aws s3 ls s3://pradeep-tfstate-379959319021/task1-ec2/
```

Expected: terraform.tfstate.

Lock test:

1. In terminal 1 run terraform apply and don't answer the prompt.
2. Open a second terminal (+ in the terminal panel) and run:

```bash
cd /workspaces/DevOps-Tasks/task1-ec2
terraform plan
```

Expected: "Error acquiring the state lock" with the lock info.

3. While terminal 1 is waiting, check DynamoDB > Tables > terraform-state-lock > Explore table items. The lock entry is there.
4. Type no in terminal 1. The lock is released and nothing changes.


## 4. Task 1 - clean up and check the final code

Remove the protection so the instances can be deleted. In main.tf set protected = false on db-server, then:

```bash
terraform apply
terraform destroy
```

Expected: all 5 instances show Terminated in the console.

Now put back the real values: io2 and iops = 100 for db-server, io1 and iops = 100 for cache-server, protected = true on db-server.

```bash
terraform plan
cd ..
```

Expected: 5 to add, with volume_type io2 and io1 in the plan. Don't apply.


## 5. Task 3 - IAM

```bash
cd task3-iam
terraform init
terraform apply
```

Wait about a minute, because new roles take a few seconds to work.

Set up a helper to switch roles:

```bash
ACCOUNT=379959319021
BUCKET=pradeep-accountb-data-379959319021

assume() {
  read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< $(aws sts assume-role \
    --role-arn arn:aws:iam::$ACCOUNT:role/$1 --role-session-name test \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text)
  export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  aws sts get-caller-identity --query Arn --output text
}
```

Groups and console access:

```bash
aws iam get-group --group-name group1 --query 'Users[].UserName'
aws iam get-group --group-name group2 --query 'Users[].UserName'
aws iam list-attached-group-policies --group-name group2 --query 'AttachedPolicies[].PolicyName'
aws iam get-login-profile --user-name engine
aws iam get-login-profile --user-name alice --query 'LoginProfile.UserName'
```

Expected: engine and ci in group1, alice and bob in group2, AdministratorAccess on group2. NoSuchEntity for engine (no console login), and "alice" for alice.

My admin user can't assume roleC:

```bash
assume roleC
```

Expected: AccessDenied.

roleB to roleC works, and roleC only has its bucket:

```bash
assume roleB
aws s3 ls
assume roleC
echo hello > /tmp/test.txt
aws s3 cp /tmp/test.txt s3://$BUCKET/
aws s3 ls s3://$BUCKET/
aws s3 rm s3://$BUCKET/test.txt
aws s3 ls
```

Expected: aws s3 ls as roleB is denied. Both assume calls work. cp, ls and rm on the bucket work. The last aws s3 ls (all buckets) is denied.

Close this terminal (trash icon) and open a new one to get the normal login back. Paste the helper again.

roleA is admin except IAM:

```bash
assume roleA
aws ec2 describe-regions --query 'Regions[0].RegionName'
aws iam list-users
```

Expected: the region is printed, list-users is denied. Close the terminal again.

Console login for group2:

```bash
cd /workspaces/DevOps-Tasks/task3-iam
terraform output -json console_passwords
```

Open https://379959319021.signin.aws.amazon.com/console in a private window and log in as alice. It asks for a new password.

```bash
cd ..
```


## 6. Task 4 - ci policy

```bash
cd task4-ci-policy
python3 -m json.tool ci-policy.json > /dev/null && echo "JSON OK"
terraform init
terraform apply
aws iam list-attached-user-policies --user-name ci --output table
```

Expected: JSON OK, 2 resources created, and ci-pipeline-policy attached to ci.

Quick check with the IAM policy simulator. The first command should be allowed and the second denied:

```bash
aws iam simulate-principal-policy --policy-source-arn arn:aws:iam::379959319021:user/ci \
  --action-names ecr:PutImage \
  --resource-arns arn:aws:ecr:ap-south-1:379959319021:repository/my-app \
  --query 'EvaluationResults[].EvalDecision'

aws iam simulate-principal-policy --policy-source-arn arn:aws:iam::379959319021:user/ci \
  --action-names s3:PutObject \
  --resource-arns arn:aws:s3:::my-build-artifacts/build.zip \
  --query 'EvaluationResults[].EvalDecision'

cd ..
```

Expected: "allowed", then "implicitDeny".


## 7. Task 5 - bug fix

```bash
cd task5-bugfix
terraform init
terraform validate
cd ..
```

Expected: "Success! The configuration is valid." Don't apply, because it uses the example account 000000000000.

Broken trust policy (user/roleB):

```bash
aws iam create-role --role-name bugfix-test \
  --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::379959319021:user/roleB"},"Action":"sts:AssumeRole"}]}'
```

Expected: MalformedPolicyDocument: Invalid principal in policy.

Fixed trust policy (role/roleB):

```bash
aws iam create-role --role-name bugfix-test \
  --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::379959319021:role/roleB"},"Action":"sts:AssumeRole"}]}' \
  --query 'Role.Arn'
aws iam delete-role --role-name bugfix-test
```

Expected: the role ARN is printed, then the test role is deleted.


## 8. Clean up everything

Task 4 first, because its policy is attached to the ci user from Task 3:

```bash
cd task4-ci-policy
terraform destroy
cd ../task3-iam
aws s3 rm s3://pradeep-accountb-data-379959319021 --recursive
terraform destroy
cd ..
```

Delete the key pairs:

```bash
for k in key-web key-app key-db key-cache key-bastion; do
  aws ec2 delete-key-pair --region ap-south-1 --key-name $k
done
```

The Task 2 bucket and table cost almost nothing, so I keep them. To remove them as well: in task2-remote-state/main.tf remove the lifecycle block from the bucket and add force_destroy = true, then:

```bash
cd task2-remote-state
terraform apply
terraform destroy
cd ..
```

Last check that nothing is left running:

```bash
aws ec2 describe-instances --region ap-south-1 \
  --filters Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[].InstanceId'
```

Expected: [].
