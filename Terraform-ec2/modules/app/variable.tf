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