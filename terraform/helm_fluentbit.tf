resource "helm_release" "fluentbit" {
  name       = "fluent-bit"
  chart      = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"

  namespace  = "fluentbit"

  create_namespace = true

  values = [
    "${file("./helm/fluentbit/values.yml")}"
  ]


  depends_on = [
  ]
}

