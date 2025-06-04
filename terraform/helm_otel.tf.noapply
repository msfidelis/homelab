resource "helm_release" "otel" {
  name       = "opentelemetry-collector"
  chart      = "opentelemetry-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  
  namespace  = "opentelemetry"

  create_namespace = true

  values = [
    "${file("./helm/otel/values.yml")}"
  ]


  depends_on = [
  ]
}