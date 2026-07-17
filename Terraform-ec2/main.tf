module "app" {
  source               = "./modules/app"
  environment          = var.environment
  app_name             = var.app_name
  image_tag            = var.image_tag
  aws_region           = var.aws_region
  cloudwatch_log_group = module.security.cloudwatch_log_group

  private_subnet_ids    = module.networking.private_subnet_ids
  ecs_security_group_id = module.security.ecs_security_group_id
  target_group_arn      = module.loadbalancer.target_group_arn

  execution_role_arn = module.security.execution_role_arn
  task_role_arn      = module.security.task_role_arn

  db_host                   = module.database.db_host
  db_port                   = module.database.db_port
  db_name                   = module.database.db_name
  db_user                   = module.database.db_user
  db_password_parameter_arn = module.database.db_password_parameter_arn


  container_port = 3000
}

module "networking" {
  source                = "./modules/networking"
  environment           = var.environment
  alb_dns_name          = module.loadbalancer.alb_dns_name
  load_balancer_zone_id = module.loadbalancer.load_balancer_zone_id
  domain_name           = "www.zakariyaalab.com"


}

module "security" {
  source   = "./modules/security"
  app_name = var.app_name

  vpc_id = module.networking.vpc_id


}

module "database" {
  source = "./modules/database"

  db_subnet_group_name  = module.networking.db_subnet_group_name
  rds_security_group_id = module.security.rds_security_group_id
  db_name               = var.db_name
  db_username           = var.db_username
  private_subnet_ids    = module.networking.private_subnet_ids
}

module "loadbalancer" {
  source = "./modules/loadbalancer"


  vpc_id                         = module.networking.vpc_id
  public_subnet_ids              = module.networking.public_subnet_ids
  alb_security_group_id          = module.security.alb_security_group_id
  acm_certificate_validation_arn = module.networking.acm_certificate_validation_arn


}




data "aws_availability_zones" "available" {
  state = "available"
}





