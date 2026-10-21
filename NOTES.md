# Notes

## Task 1 - Multi Instance EC2

All 5 instances come from one variable called instances. It is a map, and the module loops over it with for_each, so there is only one resource block for the instances instead of 5. The map key is used as the instance name.

Instances:

- web-server: t3.micro, gp3, 8 GB, key-web
- app-server: t3.small, gp2, 10 GB, key-app
- db-server: m7i-flex.large, io2 (100 IOPS), 12 GB, key-db
- cache-server: t8i.small, io1 (100 IOPS), 14 GB, key-cache
- bastion: t8i.micro, standard, 9 GB, key-bastion

Every instance has the tags Name, Environment and Owner.

The outputs are two maps: instance name to instance ID, and instance name to private IP.

I used a map instead of a list because with a list, removing one item shifts the index of the items after it, and Terraform may recreate those instances. With a map each instance is tracked by its name, so removing one doesn't affect the others.

Which instance is protected and why:

I protected db-server with prevent_destroy = true. It is the only instance that holds data. The other servers can be destroyed and rebuilt from code without losing anything, but if the database server is deleted by mistake the data is gone. This could happen with a terraform destroy in the wrong folder, or if someone renames it in the map, because Terraform would delete it and create a new one. With prevent_destroy, any plan that tries to delete db-server fails, so someone has to remove the protection on purpose first.

How I did it:

Terraform doesn't allow variables inside a lifecycle block, so I couldn't write prevent_destroy = each.value.protected. Instead I added an optional protected flag to each instance (false by default). In the module I split the map into two with locals: protected instances and normal instances. Normal instances use one resource block, and protected instances use a second block that has prevent_destroy = true. The outputs merge both blocks so all 5 instances are shown. Everything is still driven by the same single variable.

prevent_destroy only stops Terraform. Someone could still terminate the instance from the AWS console. To stop that as well I would also set disable_api_termination = true.

Testing:

My AWS account is on the Free plan, which only allows free tier instance types and blocks io1 and io2 volumes. I picked 5 different instance types from the free tier list (aws ec2 describe-instance-types with the free-tier-eligible filter). To test for free, I changed db-server and cache-server to gp3 for one run, ran terraform apply, and checked the instances, tags and outputs. Then I ran terraform plan -destroy, which failed with "Instance cannot be destroyed" for db-server, so the protection works. After that I destroyed everything and changed the volumes back to io2 and io1. The final code passes terraform plan and would apply on a paid account without changes.

Screenshots are in screenshots/task1.


## Task 2 - Remote State and Locking

The task2-remote-state folder creates:

- An S3 bucket called pradeep-tfstate-379959319021 for the state files, with versioning, encryption and public access blocked.
- A DynamoDB table called terraform-state-lock with LockID as the key, for locking.

This folder keeps its own state locally, because the bucket has to exist before anything can use it.

Then I added backend.tf in task1-ec2 that points to the bucket and the table, and ran terraform init -migrate-state to move the local state into S3. Task 3 and Task 4 use the same bucket with a different key each.

What happens today with local state if two people run apply at the same time:

The state file is on each person's own machine. Each person has their own copy, so neither of them knows what the other is changing. Both can try to create the same resources, which gives duplicates or "already exists" errors. When both finish, each state file only knows about its own changes, so resources created by the other person are not tracked and Terraform can't manage or delete them later. If the state file is shared on a network drive, two writes at the same time can also corrupt it.

How the backend change prevents that:

S3 keeps one shared state file, so everyone works from the same up to date state. DynamoDB gives locking. When someone runs plan or apply, Terraform writes a lock entry in the table. If someone else runs Terraform at the same time, it stops with "Error acquiring the state lock" and shows who has the lock. So only one person can change the state at a time, and the lock is removed when the run finishes. Versioning on the bucket also lets me go back to an older state file if something goes wrong.

Testing:

I ran terraform apply in one terminal and left it waiting at the "yes" prompt. In a second terminal I ran terraform plan and got "Error acquiring the state lock". I could also see the lock entry in the DynamoDB table. Then I typed no in the first terminal, which released the lock without creating anything.

Note: newer Terraform versions can lock with a file in S3 (use_lockfile = true) and show a warning that dynamodb_table is deprecated. I used DynamoDB because the task asked for it.


## Task 3 - Multi Account IAM

Both accounts are in one configuration, using two provider aliases: account_a and account_b.

Account A:

- group1 has engine and ci. They get access keys but no login profile, so they can use the CLI but not the console.
- group2 has alice and bob. They get a console password (must be changed on first login) and access keys, and the group has AdministratorAccess.
- roleA has a policy that allows everything except iam:* (using NotAction), so it is admin for all services except IAM.
- roleB only has permission to call sts:AssumeRole on roleC.

Account B:

- roleC has s3:* only on one bucket (pradeep-accountb-data-379959319021 and its objects). Its trust policy only allows roleB's ARN.

Testing:

I only have one AWS account, so for testing both providers point to the same account. The trust and permission rules work the same way. For a real second account I would add an assume_role block to the account_b provider (there is a comment for it in providers.tf).

I tested with the AWS CLI:

- roleB could assume roleC.
- roleC could read and write its bucket, but listing all buckets was denied.
- roleB couldn't do anything other than assume roleC.
- My admin user couldn't assume roleC directly (AccessDenied), because only roleB is trusted.
- roleA could use EC2 and S3, but IAM calls were denied.
- engine and ci have no console login. alice could log in to the console.

1. Would I give engine and ci IAM users with access keys in a real production setup?

No. Access keys don't expire. They get copied into CI settings, scripts and laptops, and if one leaks, for example pushed to GitHub, it keeps working until someone notices and rotates it. In this setup the keys are also stored in the Terraform state.

What I would do instead:

- For ci, use OIDC. GitHub Actions and most CI tools can get a short lived token and use it to assume an IAM role. The role only trusts my repo, the credentials expire after about an hour, and there are no keys to store or rotate.
- For engine, if it runs on AWS (EC2, ECS, Lambda, EKS), give it an IAM role through an instance profile or task role. AWS rotates those credentials automatically. If it runs outside AWS, IAM Roles Anywhere can be used.
- People should log in through IAM Identity Center (SSO) with MFA instead of IAM users.

If I had to use access keys anyway, I would keep them in a secrets manager, rotate them regularly and restrict them with conditions like source IP.

2. Why does it matter if roleC trusts the whole Account A root or only roleB's ARN?

Trusting arn:aws:iam::<account_a>:root doesn't mean only the root user. It means Account B trusts all of Account A and lets Account A decide who can assume the role. Any user or role in Account A that has sts:AssumeRole in its own policy could assume roleC, including roleA and the group2 admins. So Account B's bucket would only be as safe as Account A's permissions, and one mistake or one compromised user in Account A could reach it.

Trusting arn:aws:iam::<account_a>:role/roleB means only roleB can assume roleC, no matter what permissions other users in Account A have. Account B decides exactly who can get in, which is what the task asks for. I tested this: my admin user was denied when it tried to assume roleC directly.

Also, when a trust policy names a specific role, AWS saves that role's unique ID. If roleB is deleted and created again with the same name, the trust stops working until it is updated, so nobody can take over the trust just by creating a role with the same name.


## Task 4 - Least Privilege Policy for ci

The policy is in task4-ci-policy/ci-policy.json. Terraform creates it as ci-pipeline-policy and attaches it to the ci user from Task 3.

What the policy allows:

- ecr:GetAuthorizationToken so the pipeline can log in to ECR. This one can't be limited to a repo, so the resource is *.
- The 5 actions needed for docker push (BatchCheckLayerAvailability, InitiateLayerUpload, UploadLayerPart, CompleteLayerUpload, PutImage), only on the my-app repo.
- ecs:RegisterTaskDefinition and ecs:DescribeTaskDefinition to create the new task definition. These also don't support resource limits, so the resource is *.
- ecs:UpdateService and ecs:DescribeServices, only on my-app-service.
- iam:PassRole, only for the app's two task roles, and only when they are passed to ECS tasks.
- s3:ListBucket and s3:GetObject on the my-build-artifacts bucket.

What I left out and why:

- No wildcards like ecr:*, ecs:* or s3:*. They would include delete and admin actions that the pipeline doesn't need.
- No ECR delete actions and no CreateRepository. The pipeline only pushes images. The repo should be managed with Terraform, not by CI.
- No ECR pull actions. They are not needed to push. If the build used the old image as a cache, I would add them for this repo only.
- No CreateService, DeleteService, RunTask or cluster actions. A deploy only needs a new task definition and an update to the service. Creating or deleting infrastructure is not the pipeline's job.
- Only one repo and one service. If the pipeline is compromised, it can't touch other apps.
- No iam:PassRole on *. This is the most important one. If CI could pass any role, it could put an admin role in a task definition and run code as admin. So it can only pass the two task roles, and only to ECS.
- No s3:PutObject or s3:DeleteObject. The task says read only, so CI can't change or delete build artifacts.
- No s3:ListAllMyBuckets. CI doesn't need to see the other buckets.
- No other IAM permissions. CI should not be able to change its own permissions or anyone else's.


## Task 5 - Find and Fix the Bug

The fixed code is in task5-bugfix/fixed.tf. There were two problems.

Problem 1 - trust policy:

The principal was arn:aws:iam::000000000000:user/roleB. roleB is a role, not a user, so it should be arn:aws:iam::000000000000:role/roleB.

With user/roleB, AWS looks for an IAM user called roleB. That user doesn't exist, so creating the role fails with "MalformedPolicyDocument: Invalid principal in policy". Even if a user with that name existed, it would be a different identity from the role. When the real roleB calls sts:AssumeRole its ARN is role/roleB, which doesn't match, so it would get AccessDenied. This is the reason roleB couldn't assume roleC.

Problem 2 - permissions policy:

The policy had s3:* on Resource = "*". That gives roleC full access to every bucket in Account B, including deleting them, but the requirement is access to one bucket only. Terraform applies it without any error because it is valid, so it is a security problem, not a syntax error.

I changed the resource to the bucket ARN and the bucket ARN with /*. Both are needed. The bucket ARN is for bucket level actions like ListBucket, and bucket/* is for object level actions like GetObject and PutObject. With only one of them, part of the access would be denied.

Testing:

I created a test role with the broken trust policy (user/roleB) and AWS rejected it with "MalformedPolicyDocument: Invalid principal in policy". With role/roleB the role was created. I deleted the test role afterwards.

Also, the trust policy is only one side. For cross account access, roleB in Account A also needs permission to call sts:AssumeRole on roleC. That part is in task3-iam/account_a.tf.
