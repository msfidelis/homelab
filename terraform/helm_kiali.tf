resource "helm_release" "kiali-server" {
  name             = "kiali-server"
  chart            = "kiali-server"
  repository       = "https://kiali.org/helm-charts"
  namespace        = "istio-system"
  create_namespace = true

  version = "2.5"

  set {
    name  = "server.web_fqdn"
    value = "kiali.homelab.msfidelis.com.br"
  }

  set {
    name  = "auth.strategy"
    value = "anonymous"
  }

  set {
    name  = "external_services.tracing.enabled"
    value = true
  }
  set {
    name  = "external_services.tracing.use_grpc"
    value = false
  }

  set {
    name  = "external_services.tracing.internal_url"
    value = "http://jaeger-query.tracing.svc.cluster.local:16686"
  }

  set {
    name  = "external_services.tracing.external_url"
    value = "http://jaeger.homelab.msfidelis.com.br"
  }


  set {
    name  = "external_services.prometheus.url"
    value = "http://prometheus-kube-prometheus-prometheus.prometheus.svc.cluster.local:9090"
  }

  set {
    name  = "external_services.grafana.enabled"
    value = true
  }

  set {
    name  = "external_services.grafana.external_url"
    value = "http://grafana.homelab.msfidelis.com.br"
  }


  set {
    name  = "external_services.grafana.internal_url"
    value = "http://prometheus-grafana.prometheus.svc.cluster.local:80"
  }


  set {
    name  = "external_services.grafana.dashboards[0].name"
    value = "Istio Mesh Dashboard"
  }

  set {
    name  = "external_services.grafana.dashboards[1].name"
    value = "Istio Service Dashboard"
  }

  set {
    name  = "external_services.grafana.dashboards[2].name"
    value = "Istio Workload Dashboard"
  }

  set {
    name  = "external_services.grafana.dashboards[3].name"
    value = "Istio Performance Dashboard"
  }

  set {
    name  = "external_services.grafana.dashboards[4].name"
    value = "Istio Wasm Extension Dashboard"
  }

  set {
    name  = "external_services.grafana.auth.type"
    value = "basic"
  }

  set {
    name  = "external_services.grafana.auth.insecure_skip_verify"
    value = "true"
  }

  set {
    name  = "external_services.grafana.auth.username"
    value = "admin"
  }

  set {
    name  = "external_services.grafana.auth.password"
    value = "prom-operator"
  }



  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "kubectl_manifest" "kiali_gateway" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: kiali-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway 
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - kiali.homelab.msfidelis.com.br
YAML

  depends_on = [
    helm_release.kiali-server,
    helm_release.istio_base,
    helm_release.istiod
  ]

}

resource "kubectl_manifest" "kiali_virtual_service" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: kiali
  namespace: istio-system
spec:
  hosts:
  - kiali.homelab.msfidelis.com.br
  gateways:
  - kiali-gateway
  http:
  - match:
    - uri:
        prefix: /
    route:
    - destination:
        host: kiali
        port:
          number: 20001
YAML

  depends_on = [
    helm_release.kiali-server,
    helm_release.istio_base,
    helm_release.istiod
  ]

}