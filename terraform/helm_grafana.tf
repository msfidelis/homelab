# resource "helm_release" "grafana" {
#   name       = "grafana"
#   chart      = "grafana"
#   repository = "https://grafana.github.io/helm-charts"
#   namespace  = "grafana"

#   create_namespace = true

#   values = [
#     "${file("./helm/grafana/values.yml")}"
#   ]


#   depends_on = [
#   ]
# }

# resource "kubectl_manifest" "grafana_gateway" {

#   yaml_body = <<YAML
# apiVersion: networking.istio.io/v1alpha3
# kind: Gateway
# metadata:
#   name: grafana
#   namespace: grafana
# spec:
#   selector:
#     istio: ingressgateway 
#   servers:
#   - port:
#       number: 80
#       name: http
#       protocol: HTTP
#     hosts:
#     - grafana-stack.homelab.msfidelis.com.br
# YAML

#   depends_on = [
#     helm_release.grafana,
#   ]

# }

# resource "kubectl_manifest" "grafana_virtual_service" {

#   yaml_body = <<YAML
# apiVersion: networking.istio.io/v1alpha3
# kind: VirtualService
# metadata:
#   name: grafana
#   namespace: grafana
# spec:
#   hosts:
#   - grafana-stack.homelab.msfidelis.com.br
#   gateways:
#   -  grafana
#   http:
#   - match:
#     - uri:
#         prefix: /
#     route:
#     - destination:
#         host: grafana
#         port:
#           number: 80
# YAML

#   depends_on = [
#     helm_release.grafana,
#   ]

# }