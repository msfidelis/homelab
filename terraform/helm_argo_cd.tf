resource "helm_release" "argocd" {

  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  // toor
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = "$2a$10$GxWjaA6lo6HJUTHjzuPcfOyCUjt0FdIrD7NaiWMNlUlWKtjJeu1r2"
  }

  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  set {
    name  = "server.extensions.enabled"
    value = "true"
  }

  set {
    name  = "server.enable.proxy.extension"
    value = "true"
  }

  set {
    name  = "server.extensions.image.repository"
    value = "quay.io/argoprojlabs/argocd-extension-installer"
  }

  set {
    name  = "server.extensions.extensionList[0].name"
    value = "rollout-extension"
  }

  set {
    name  = "server.extensions.extensionList[0].env[0].name"
    value = "EXTENSION_URL"
  }

  set {
    name  = "server.extensions.extensionList[0].env[0].value"
    value = "https://github.com/argoproj-labs/rollout-extension/releases/download/v0.3.6/extension.tar"
  }

  set {
    name  = "applicationSet.extraArgs[0]"
    value = "--enable-progressive-syncs"
  }

  depends_on = [ helm_release.istio_ingress ]

}

resource "kubectl_manifest" "argo_gateway" {

  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: argocd-gateway
  namespace: argocd
spec:
  selector:
    istio: ingressgateway 
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - argocd.homelab.fidelissauro.dev
YAML

  depends_on = [
    helm_release.argocd,
  ]

}


resource "kubectl_manifest" "argocd_virtual_service" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: argo-server
  namespace: argocd
spec:
  hosts:
  - argocd.homelab.fidelissauro.dev
  gateways:
  - argocd-gateway
  http:
  - match:
    - uri:
        prefix: /
    route:
    - destination:
        host: argocd-server
        port:
          number: 80
YAML

  depends_on = [
    helm_release.argocd
  ]

}