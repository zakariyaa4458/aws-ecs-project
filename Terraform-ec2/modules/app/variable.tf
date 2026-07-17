variable "environment" {
  type        = string
  description = "Environment for the instance"
  #  default     = "production"
}

variable "app_name" {
  type        = string
  description = "Name of the application"
  default     = "my-app"
}

variable "image_tag" {
  type        = string
  description = "docker image tag"
}

variable "aws_region" {
  type        = string
  description = "AWS region for the instance"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_port" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password_parameter_arn" {
  type = string
}

variable "container_port" {
  type    = number
  default = 3000
}

variable "ecr_repository_name" {

  type   = string
  default = "threat-composer"

}

variable "cloudwatch_log_group" {

  type = string
  
}