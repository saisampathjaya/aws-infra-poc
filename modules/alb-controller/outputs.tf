output "alb_controller_name" {
  value = helm_release.alb_controller.name
}

output "alb_controller_namespace" {
  value = helm_release.alb_controller.namespace
}