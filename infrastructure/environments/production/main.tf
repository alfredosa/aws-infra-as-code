
module "networking" {
  source = "../../modules/networking"

  environment = "production"
  organization_name = var.organization_name
}

module "load_balancer" {
  source = "../../modules/load_balancer"

  vpc_id = module.networking.vpc_id

  environment = "production"
  public_subnet_1_id = module.networking.public_subnet_1_id
  public_subnet_2_id = module.networking.public_subnet_2_id
}

module "ses" {
    source = "../../modules/ses"
    
    domain = var.domain
    environment = "production"
}

module "ecr" {
    source = "../../modules/ecr"
    
    environment = "production"
    org_name = var.organization_name
}

module "cloudwatch_group" {
    source = "../../modules/cloudwatch"
    
    environment = "production"
}

module "ecs_cluster" {
  source = "../../modules/ecs/cluster"

  environment = "production"
  org_name = var.organization_name
}

module "rds_postgres_db_metabase" {
  source = "../../modules/rds"

  environment = "production"
  org_name = var.organization_name
  ecs_cluster_security_group_id = module.ecs_cluster.cluster_security_group_id
  dedicated_service = "metabase"
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  vpc_id = module.networking.vpc_id
  private_subnet_group_name = module.networking.private_subnet_group_name
  db_instance_class = "db.t3.micro"
}

module "metabase_ecs_service" {
  source = "../../modules/ecs/metabase"

  environment = "production"
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_host = module.rds_postgres_db_metabase.db_host
  region = var.region
  metabase_task_role_arn = null
  cloutwatch_group_name = module.cloudwatch_group.name
  ecs_cluster_id = module.ecs_cluster.id
  load_balancer_arn = module.load_balancer.arn
  public_subnet_ids = [module.networking.public_subnet_1_id, module.networking.public_subnet_2_id]
  cluster_security_group_id = module.ecs_cluster.cluster_security_group_id
  cluster_execution_role_arn = module.ecs_cluster.cluster_execution_role_arn
  task_role_arn = module.ecs_cluster.task_role_arn
  
}

module "s3_data_lake" {
  source = "../../modules/s3"

  environment = "production"
  organization_name = var.organization_name
  bucket_name = "data-lake"
}