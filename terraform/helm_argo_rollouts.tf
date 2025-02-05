resource "helm_release" "argo_rollouts" {

  name       = "argo-rollouts"
  chart      = "argo-rollouts"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argo-rollouts"

  version = "2.34.1"

  create_namespace = true

  set {
    name  = "dashboard.enabled"
    value = false
  }

  set {
    name  = "controller.metrics.enabled"
    value = true
  }

  set {
    name  = "podAnnotations.prometheus\\.io/scrape"
    value = true
  }

  set {
    name  = "podAnnotations.prometheus\\.io/path"
    value = "/metrics"
  }

  set {
    name  = "podAnnotations.prometheus\\.io/port"
    value = "8090"
  }


  depends_on = [
  ]
}