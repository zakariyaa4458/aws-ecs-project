variable "app_name" {
  type        = string
  description = "Name of the application"
  default     = "my-app"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC used by the security groups"
}
