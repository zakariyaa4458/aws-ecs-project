module "app" {
  source      = "./modules/app"
  environment = var.environment
  app_name    = var.app_name
  image_tag   = var.image_tag
  aws_region  = var.aws_region
}

module "networking" {
  source      = "./modules/networking"
  environment = var.environment

}

module "security" {
  source   = "./modules/security"
  app_name = var.app_name
}

module "database" {
  source = "./modules/database"
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
}




data "aws_availability_zones" "available" {
  state = "available"
}





