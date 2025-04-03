resource "helm_release" "argo_events" {

  name       = "argo-events"
  chart      = "argo-events"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argo-events"

  version = "2.4.14"

  create_namespace = true

  depends_on = [
  ]
}

resource "kubectl_manifest" "argo_events_event_bus" {

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: EventBus
metadata:
  name: default
  namespace: argo-events
spec:
  jetstream:
    version: latest
YAML

  depends_on = [
    helm_release.argo_events
  ]

}


resource "kubectl_manifest" "argo_events_role" {

  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: argo-events-operation-role
  namespace: argocd
rules:
  - apiGroups: ["argoproj.io"]
    resources: ["applicationsets"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["argoproj.io"]
    resources: ["workflows"]
    verbs: ["*"]
YAML

  depends_on = [
    helm_release.argo_events
  ]

}

resource "kubectl_manifest" "argo_events_role_binding" {

  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: argo-events-operation-role-binding
  namespace: argocd
subjects:
  - kind: ServiceAccount
    name: default
    namespace: argo-events
roleRef:
  kind: Role
  name: argo-events-operation-role
  apiGroup: rbac.authorization.k8s.io
YAML

  depends_on = [
    kubectl_manifest.argo_events_role
  ]

}


resource "kubectl_manifest" "argo_events_workflow_role" {

  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: argo-events-operation-workflows-role
  namespace: argo-workflows
rules:
  - apiGroups: ["argoproj.io"]
    resources: ["workflows"]
    verbs: ["*"]
YAML

  depends_on = [
    helm_release.argo_events
  ]

}

resource "kubectl_manifest" "argo_events_workflow_role_binding" {

  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: argo-events-operation-workflows-role-binding
  namespace: argo-workflows
subjects:
  - kind: ServiceAccount
    name: default
    namespace: argo-events
roleRef:
  kind: Role
  name: argo-events-operation-workflows-role
  apiGroup: rbac.authorization.k8s.io
YAML

  depends_on = [
    kubectl_manifest.argo_events_workflow_role
  ]

}

