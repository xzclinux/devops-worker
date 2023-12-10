module "helm_chart" {
  source = "./helm"
  domain = var.domain
  kubeconfigpath =var.kubeconfigpath
  server_ips =var.server_ips
  password =var.password
  agent_ips =var.agent_ips
  port = var.port
  sonar_password=var.sonar_password
}


resource "null_resource" "connect_master" {
  depends_on = [module.helm_chart]
  connection {
    host     = var.server_ips[0]
    type     = "ssh"
    user     = "root"
    port     = var.port
    password = var.password
    //private_key = file("ssh-key/id_rsa")
    //agent = false
  }


  // init.sh
  provisioner "file" {
    destination = "/tmp/init.sh"
    content = templatefile(
      "${path.module}/init.sh.tpl",
      {
        "public_ip" : "${var.server_ips[0]}"
        "domain" : "${var.domain}",
        "gitlab_host" : "https://gitlab.${var.domain}"
        "harbor_registry" : "${var.registry}"
        "harbor_password" : "${var.harbor_password}"
        "example_project_name" : "${var.example_project_name}"
        "sonar_password" : "${var.sonar_password}"
        "jenkins_password" : "${var.jenkins_password}"
        "argocd_password" : "${var.argocd_password}"
      }
    )
  }




  provisioner "file" {
    destination = "/tmp/jenkins-harbor-url-secret.yaml"
    content = templatefile(
      "${path.module}/jenkins/harbor-url-secret.yaml.tpl",
      {
        "domain" : "${var.domain}"
      }
    )
  }

  provisioner "file" {
    source      = "jenkins/github-pull-secret.yaml"
    destination = "/tmp/github-pull-secret.yaml"
  }

  # argocd
  provisioner "file" {
    source      = "argocd/repo-secret.yaml"
    destination = "/tmp/repo-secret.yaml"
  }

  provisioner "file" {
    source      = "argocd/applicationset.yaml"
    destination = "/tmp/applicationset.yaml"
  }

  provisioner "file" {
    source      = "argocd/dashboard.yaml"
    destination = "/tmp/argocd-dashboard.yaml"
  }
  provisioner "file" {
    source      = "argocd/values.yaml.tpl"
    destination = "/tmp/argocd-vaules.yaml"
  }

  provisioner "file" {
    destination = "/tmp/argocd-image-updater-config.yaml"
    content = templatefile(
      "${path.module}/argocd/argo-image-updater-config.yaml.tpl",
      {
        "domain" : "${var.domain}"
      }
    )
  }

  provisioner "remote-exec" {

    # script = "/tmp/init.sh"
    inline = [
      "chmod +x /tmp/init.sh",
      "sh /tmp/init.sh",
    ]
  }
}