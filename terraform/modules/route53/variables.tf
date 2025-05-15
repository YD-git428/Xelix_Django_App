variable "domain_name" {
  type = string
}

variable "lb_dns_name" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "ecs_service_id" {
  type = string
}

variable "alarm_name" {
  type = string
}

variable "cloudwatch_tag" {
  type = string
}

variable "sns_topic_name" {
  type = string
}

variable "email" {
  type = string
}

variable "healthcheck_tag" {
  type = string
}

variable "ttl" {
  type = number
}

variable "log_group_name" {
  type = string
}