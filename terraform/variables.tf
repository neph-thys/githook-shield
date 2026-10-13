
variable "kube_context" {
  description = "Kubernetes context used by Terraform"
  type        = string
  default     = "minikube"
}

variable "namespace" {
  description = "Namespace for the application"
  type        = string
  default     = "githook-shield"
}

variable "app_image" {
  description = "Locally available Docker image"
  type        = string
  default     = "githook-shield:1.0"
}

variable "replicas" {
  description = "Number of application replicas"
  type        = number
  default     = 1

  validation {
    condition     = var.replicas >= 1 && var.replicas <= 3
    error_message = "Replicas must be between 1 and 3."
  }
}
