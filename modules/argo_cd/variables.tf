variable "name" {
  description = "Назва Helm-релізу"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Версія Argo CD чарта"
  type        = string
  default     = "5.46.4"
}

variable "github_repo_url" {
  description = "GitHub repository URL for Argo CD to monitor"
  type        = string
}

variable "github_user" {
  description = "GitHub username for repository access"
  type        = string
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "app_target_revision" {
  description = "Git branch/tag for Argo CD application"
  type        = string
  default     = "lesson-8-9"
}