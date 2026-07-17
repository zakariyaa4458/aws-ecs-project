variable "environment" {
  type        = string
  description = "Environment for the instance"
  #  default     = "production"
}

variable "alb_dns_name" {
  type = string
  description = "alb dns name"
  
}

variable "load_balancer_zone_id" {
  type = string
  description = "load balancer zone id"
  
}

variable "domain_name" {
  type = string
}