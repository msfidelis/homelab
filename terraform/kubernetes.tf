provider "kubernetes" {
  config_path = "/Users/fidelis/Workspace/homelab/k3s/control-plane.yaml"
}

provider "helm" {
  kubernetes {
    config_path = "/Users/fidelis/Workspace/homelab/k3s/control-plane.yaml"
  }
}