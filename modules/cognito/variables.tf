variable "default_username" {
  description = "Default username to create in the user pool"
  type        = string
  default     = "lokesh"
}

variable "default_email" {
  description = "Default email for the user"
  type        = string
  default     = "chlokesh1306@gmail.com"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "Default profile"
  type        = string
  default     = "infra"
}