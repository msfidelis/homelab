resource "helm_release" "tempo" {
  name       = "tempo"
  chart      = "tempo-distributed"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "tempo"

  create_namespace = true

  values = [
    "${file("./helm/tempo/values.yml")}"
  ]


  depends_on = [
  ]
}