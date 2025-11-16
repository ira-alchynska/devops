resource "helm_release" "argo_cd" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  create_namespace = true
}

locals {
  charts_values = templatefile("${path.module}/charts/values.yaml", {
    github_repo_url      = var.github_repo_url
    github_user          = var.github_user
    github_pat           = var.github_pat
    app_target_revision  = var.app_target_revision
  })
}

resource "helm_release" "argo_apps" {
  name             = "${var.name}-apps"
  chart            = "${path.module}/charts"
  namespace        = var.namespace
  create_namespace = false

  values = [
    local.charts_values
  ]
  depends_on = [helm_release.argo_cd]
}

