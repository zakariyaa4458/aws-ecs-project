terraform {
  backend "s3" {
    bucket       = "aws-project-terraform-state-123456"
    key          = "ecs-assignment/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

