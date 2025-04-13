resource "helm_release" "loki" {
  name       = "loki"
  chart      = "loki"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "loki"

  create_namespace = true

  values = [
    "${file("./helm/loki/values.yml")}"
  ]


  depends_on = [
  ]
}