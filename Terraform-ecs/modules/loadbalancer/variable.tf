variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  description = "Security Group id for the ALB"
  type = string
}

variable "acm_certificate_validation_arn" {
 type = string
  
}