output "website_url" {
  value       = module.compute.alb_dns_name
  description = "Public URLL to access deployed web application"
}
