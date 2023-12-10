terraform {
  backend "kubernetes" {
    secret_suffix    = "state"
    config_path      = "~/../worker01/init/kubeconfig.yaml"
  }
}
