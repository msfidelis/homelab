resource "helm_release" "prometheus" {

  name             = "prometheus"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "prometheus"
  create_namespace = true

  version = "45.8.0"

  values = [
    "${file("./helm/prometheus/values.yml")}"
  ]


  depends_on = [
  ]
}

# resource "kubectl_manifest" "grafana_gateway" {

#   yaml_body = <<YAML
# apiVersion: networking.istio.io/v1alpha3
# kind: Gateway
# metadata:
#   name: grafana
#   namespace: prometheus
# spec:
#   selector:
#     istio: ingressgateway 
#   servers:
#   - port:
#       number: 80
#       name: http
#       protocol: HTTP
#     hosts:
#     - grafana.homelab.msfidelis.com.br
# YAML

#   depends_on = [
#     helm_release.istio_base,
#     helm_release.prometheus
#   ]

# }

# resource "kubectl_manifest" "grafana_service" {

#   yaml_body = <<YAML
# apiVersion: networking.istio.io/v1alpha3
# kind: VirtualService
# metadata:
#   name: grafana
#   namespace: prometheus
# spec:
#   hosts:
#   - grafana.homelab.msfidelis.com.br
#   gateways:
#   - grafana
#   http:
#   - match:
#     - uri:
#         prefix: /
#     route:
#     - destination:
#         host: prometheus-grafana
#         port:
#           number: 80
# YAML

#   depends_on = [
#     helm_release.istio_base,
#     helm_release.prometheus
#   ]

# }

# # resource "kubectl_manifest" "podmonitor_generic" {

# #   yaml_body = <<YAML
# # apiVersion: monitoring.coreos.com/v1
# # kind: PodMonitor
# # metadata:
# #   name: generic-stats-monitor
# #   namespace: prometheus
# #   labels:
# #     monitoring: istio-proxies
# #     release: istio
# # spec:
# #   selector:
# #     matchExpressions:
# #     - {key: istio-prometheus-ignore, operator: DoesNotExist}
# #   namespaceSelector:
# #     any: true
# #   jobLabel: generic-stats
# #   podMetricsEndpoints:
# #   - path: /metrics
# #     interval: 15s
# #     relabelings:
# #     - action: keep
# # YAML

# #   depends_on = [
# #     helm_release.istio_base,
# #     helm_release.prometheus
# #   ]

# # }


# resource "kubectl_manifest" "servicemonitor_istio" {

#   yaml_body = <<YAML
# apiVersion: monitoring.coreos.com/v1
# kind: ServiceMonitor
# metadata:
#   name: istio-monitor
#   namespace: prometheus
#   labels:
#     release: prometheus
# spec:
#   namespaceSelector:
#     any: true
#   selector:
#     matchLabels:
#       istio: pilot 
#   endpoints:
#   - port: http-monitoring
# YAML

#   depends_on = [
#     helm_release.istio_base,
#     helm_release.prometheus
#   ]

# }

# resource "kubectl_manifest" "servicemonitor_istio_ingress" {

#   yaml_body = <<YAML
# apiVersion: monitoring.coreos.com/v1
# kind: ServiceMonitor
# metadata:
#   name: istio-ingress-monitor
#   namespace: prometheus
#   labels:
#     release: prometheus
# spec:
#   namespaceSelector:
#     any: true
#   selector:
#     matchLabels:
#       istio: ingress 
#   endpoints:
#   - port: http-monitoring
# YAML

#   depends_on = [
#     helm_release.istio_base,
#     helm_release.prometheus
#   ]

# }


# # resource "kubectl_manifest" "servicemonitor_istio_envoy" {

# #   yaml_body = <<YAML
# # apiVersion: monitoring.coreos.com/v1
# # kind: ServiceMonitor
# # metadata:
# #   name: istio-envoy-monitor
# #   namespace: prometheus
# # spec:
# #   namespaceSelector:
# #     any: true
# #   selector:
# #     matchExpressions:
# #     - {key: app, operator: Exists}
# #   endpoints:
# #   - targetPort: 15090
# #     interval: 15s
# #     path: /stats/prometheus
# # YAML

# #   depends_on = [
# #     helm_release.istio_base,
# #     helm_release.prometheus
# #   ]

# # }

# resource "kubectl_manifest" "podmonitor_stats_monitor" {

#   yaml_body = <<YAML
# apiVersion: monitoring.coreos.com/v1
# kind: PodMonitor
# metadata:
#   name: envoy-stats-monitor
#   namespace: istio-system
#   labels:
#     monitoring: istio-proxies
#     release: istio
# spec:
#   selector:
#     matchExpressions:
#     - {key: istio-prometheus-ignore, operator: DoesNotExist}
#   namespaceSelector:
#     any: true
#   jobLabel: envoy-stats
#   podMetricsEndpoints:
#   - path: /stats/prometheus
#     interval: 15s
#     relabelings:
#     - action: keep
#       sourceLabels: [__meta_kubernetes_pod_container_name]
#       regex: "istio-proxy"
#     - action: keep
#       sourceLabels: [__meta_kubernetes_pod_annotationpresent_prometheus_io_scrape]
#     - action: replace
#       regex: (\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})
#       replacement: '[$2]:$1'
#       sourceLabels:
#       - __meta_kubernetes_pod_annotation_prometheus_io_port
#       - __meta_kubernetes_pod_ip
#       targetLabel: __address__
#     - action: replace
#       regex: (\d+);((([0-9]+?)(\.|$)){4})
#       replacement: $2:$1
#       sourceLabels:
#       - __meta_kubernetes_pod_annotation_prometheus_io_port
#       - __meta_kubernetes_pod_ip
#       targetLabel: __address__
#     - action: labeldrop
#       regex: "__meta_kubernetes_pod_label_(.+)"
#     - sourceLabels: [__meta_kubernetes_namespace]
#       action: replace
#       targetLabel: namespace
#     - sourceLabels: [__meta_kubernetes_pod_name]
#       action: replace
#       targetLabel: pod_name
# YAML

#   depends_on = [
#     helm_release.istio_base,
#     helm_release.prometheus
#   ]

# }

# resource "kubectl_manifest" "servicemonitor_istio_component_monitor" {

#   yaml_body = <<YAML
# apiVersion: monitoring.coreos.com/v1
# kind: ServiceMonitor
# metadata:
#   name: istio-component-monitor
#   namespace: istio-system
#   labels:
#     monitoring: istio-components
#     release: istio
# spec:
#   jobLabel: istio
#   targetLabels: [app]
#   selector:
#     matchExpressions:
#     - {key: istio, operator: In, values: [pilot]}
#   namespaceSelector:
#     any: true
#   endpoints:
#   - port: http-monitoring
#     interval: 15s
# YAML

#   depends_on = [
#     helm_release.istio_base,
#     helm_release.prometheus
#   ]

# }