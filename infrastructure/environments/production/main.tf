module "networking" {
  source = "../../modules/networking"

  environment = "production"
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
    source = "../../modules/cloudwatch_group"
    
    environment = "production"
}

