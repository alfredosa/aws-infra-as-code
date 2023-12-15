
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
  vpc_id = module.networking.vpc_id
  load_balancer_security_group_ids = module.load_balancer.load_balancer_security_group_ids
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
  cloudwatch_group_name = module.cloudwatch_group.cloudwatch_group_name
  ecs_cluster_id = module.ecs_cluster.cluster_id
  
  // need to move to metabase
  load_balancer_target_group_arn = module.load_balancer.metabase_lb_target_group_arn 
  
  public_subnet_ids = [module.networking.public_subnet_1_id, module.networking.public_subnet_2_id]
  cluster_security_group_id = module.ecs_cluster.cluster_security_group_id
  org_name = var.organization_name
}

module "s3_data_lake" {
  source = "../../modules/s3"

  environment = "production"
  organization_name = var.organization_name
  bucket_name = "data-lake"
}