module "k3s_node01" {
  source         = "xunleii/k3s/module"
  k3s_version    = "v1.26.7+k3s1"
  cluster_domain = "k3s01"
  cidr = {
    pods     = "10.2.0.0/16"
    services = "10.3.0.0/16"
  }
  drain_timeout  = "30s"
  managed_fields = ["label", "taint"]
  global_flags = [
    "--tls-san ${tencentcloud_instance.cvm_postpaid[0].public_ip}",
    "--write-kubeconfig-mode 644",
    "--disable=traefik",
    "--kube-controller-manager-arg bind-address=0.0.0.0",
    "--kube-proxy-arg metrics-bind-address=0.0.0.0",
    "--kube-scheduler-arg bind-address=0.0.0.0"
  ]
  k3s_install_env_vars = {}
  servers = {
    # The node name will be automatically provided by
    # the module using the field name... any usage of
    # --node-name in additional_flags will be ignored
    server-one = {
      ip = tencentcloud_instance.cvm_postpaid[0].private_ip // internal node IP
      connection = {
        timeout  = "60s"
        type     = "ssh"
        host     = tencentcloud_instance.cvm_postpaid[0].public_ip // public node IP
        user     = "root"
        password = tencentcloud_instance.cvm_postpaid[0].password
      }
      # flags  = ["--flannel-backend=none"]
      labels = { "node.kubernetes.io/type" = "master" }
      # taints = { "node.k3s.io/type" = "server:NoSchedule" }
    }

  }

}

resource "local_sensitive_file" "kubeconfig" {
  depends_on = [module.k3s_node01]
  content    = module.k3s_node01.kube_config
  filename   = "${path.module}/kubeconfig-node01.yaml"
}

module "k3s_node02" {
  source         = "xunleii/k3s/module"
  k3s_version    = "v1.26.7+k3s1"
  cluster_domain = "k3s01"
  cidr = {
    pods     = "10.4.0.0/16"
    services = "10.5.0.0/16"
  }
  drain_timeout  = "30s"
  managed_fields = ["label", "taint"]
  global_flags = [
    "--tls-san ${tencentcloud_instance.cvm_postpaid[1].public_ip}",
    "--write-kubeconfig-mode 644",
    "--disable=traefik",
    "--kube-controller-manager-arg bind-address=0.0.0.0",
    "--kube-proxy-arg metrics-bind-address=0.0.0.0",
    "--kube-scheduler-arg bind-address=0.0.0.0"
  ]
  k3s_install_env_vars = {}
  servers = {
    # The node name will be automatically provided by
    # the module using the field name... any usage of
    # --node-name in additional_flags will be ignored
    server-one = {
      ip = tencentcloud_instance.cvm_postpaid[0].private_ip // internal node IP
      connection = {
        timeout  = "60s"
        type     = "ssh"
        host     = tencentcloud_instance.cvm_postpaid[0].public_ip // public node IP
        user     = "root"
        password = tencentcloud_instance.cvm_postpaid[0].password
      }
      # flags  = ["--flannel-backend=none"]
      labels = { "node.kubernetes.io/type" = "master" }
      # taints = { "node.k3s.io/type" = "server:NoSchedule" }
    }

  }

}

resource "local_sensitive_file" "kubeconfig" {
  depends_on = [module.k3s_node02]
  content    = module.k3s_node02.kube_config
  filename   = "${path.module}/kubeconfig-node02.yaml"
}