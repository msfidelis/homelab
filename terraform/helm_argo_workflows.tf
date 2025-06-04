# resource "helm_release" "argo_workflows" {

#   name       = "argo-workflows"
#   chart      = "argo-workflows"
#   repository = "https://argoproj.github.io/argo-helm"
#   namespace  = "argo-workflows"

#   version = "0.45.11"

#   create_namespace = true

#   set {
#     name  = "controller.namespaceParallelism"
#     value = "10"
#   }

#   set {
#     name  = "workflow.serviceAccount.create"
#     value = true
#   }

#   set {
#     name  = "server.authModes[0]"
#     value = "server"
#   }

#   depends_on = [
#   ]
# }

# resource "kubectl_manifest" "argo_workflows_gateway" {

#   yaml_body = <<YAML
# apiVersion: networking.istio.io/v1alpha3
# kind: Gateway
# metadata:
#   name: argo-workflows-server
#   namespace: argo-workflows
# spec:
#   selector:
#     istio: ingressgateway 
#   servers:
#   - port:
#       number: 80
#       name: http
#       protocol: HTTP
#     hosts:
#     - argo-workflows.homelab.msfidelis.com.br
# YAML

#   depends_on = [
#     helm_release.argo_workflows,
#   ]

# }

# resource "kubectl_manifest" "argo_workflows_virtual_service" {

#   yaml_body = <<YAML
# apiVersion: networking.istio.io/v1alpha3
# kind: VirtualService
# metadata:
#   name: argo-workflows-server
#   namespace: argo-workflows
# spec:
#   hosts:
#   - argo-workflows.homelab.msfidelis.com.br
#   gateways:
#   -  argo-workflows-server
#   http:
#   - match:
#     - uri:
#         prefix: /
#     route:
#     - destination:
#         host: argo-workflows-server
#         port:
#           number: 2746
# YAML

#   depends_on = [
#     helm_release.argo_workflows,
#   ]

# }