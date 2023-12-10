provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubeconfig.yaml"
  }

}

resource "helm_release" "nginx_ingress" {
  depends_on = [module.k3s]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.8.3"
  timeout    = "600"
}


resource "helm_release" "jenkins" {
  depends_on = [helm_release.nginx_ingress]

  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  namespace        = "jenkins"
  create_namespace = "true"
  timeout          = "600"

  values = [
    templatefile("${path.module}/jenkins-variables.yaml.tpl",
      { "domain" : "${var.prefix}.${var.domain}" }
    )
  ]
}

resource "helm_release" "argocd" {
  depends_on = [helm_release.nginx_ingress]

  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.36.6"
  create_namespace = "true"
  timeout          = "600"

  values = [
    templatefile("${path.module}/argocd-values.yaml.tpl",
      { "domain" : "${var.prefix}.${var.domain}" }
    )
  ]
}

resource "helm_release" "cert-manager" {
  depends_on = [helm_release.nginx_ingress]

  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = "true"
  timeout          = "600"

  set {
    name  = "installCRDs"
    value = "true"
  }
}