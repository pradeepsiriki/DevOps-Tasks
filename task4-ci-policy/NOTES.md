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