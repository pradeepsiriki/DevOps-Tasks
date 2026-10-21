### Proof
| Requirement | Test | Result |
|---|---|---|
| roleB can assume roleC | assume roleB → assume roleC | Success |
| roleC full access to one bucket only | s3 cp / ls on bucket; s3 ls all | Bucket works, others denied |
| roleB has no other permissions | s3 ls / ec2 describe as roleB | AccessDenied |
| roleC not assumable by others in Account A | admin user assumes roleC | AccessDenied |
| roleA admin except IAM | s3/ec2 work, iam list-users | IAM denied |
| group2 console + CLI | logged in as alice | Success |
| group1 CLI only | engine/ci have no console sign-in | Not enabled |