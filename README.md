# terraform-ecs

Replace the variables inside *variable.tf* with your iac Workspace ID, Account ID and API Key. 

## Trigger this with 
```console
terraform init
terraform apply -var="access_key=xxxxxx" -var="secret_key=yyyyyyy" 
```

This will create:
1. ECS cluster
2. ECS service with Metabasae
3. ECS service with PGAdmin
4. RDS Postgres for Metabase
5. ALB for Metabase
6. ALB for PGAdmin
7. Security groups for Metabase and PGAdmin
8. IAM roles for Metabase and PGAdmin
9. IAM policies for Metabase and PGAdmin
10. MWAA environment
11. S3 bucket for MWAA
12. S3 bucket for Data Lake