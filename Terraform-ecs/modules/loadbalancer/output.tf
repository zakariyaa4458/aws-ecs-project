output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.web-lb.dns_name
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.alb-tg.arn
}



output "load_balancer_zone_id" {
  description = "Hosted zone ID of the application load balancer"
  value       = aws_lb.web-lb.zone_id
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_lb_listener.app.arn
}