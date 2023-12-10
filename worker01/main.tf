module "init" {
  source             = "./init"
  domain             = var.domain
  password           = var.password
  ak                 = var.ak
  sk                 = var.sk
  region             = var.region
  cloudflare_api_key = var.cloudflare_api_key
  prefix             = var.prefix
}


resource "null_resource" "connect_master" {
  depends_on = [module.init]
  connection {
    host     = module.init.public_ip
    type     = "ssh"
    user     = "root"
    port     = "22"
    password = var.password
    //private_key = file("ssh-key/id_rsa")
    //agent = false
  }


  // init.sh
  provisioner "file" {
    destination = "/tmp/init.sh"
    source      = "${path.module}/init.sh"
  }



  # argocd
  provisioner "file" {
    destination = "/tmp/jenkins-secret.yaml"
    content = templatefile(
      "${path.module}/cert/cert-manager-cloudflare-secret.yaml.tpl",
      {
        "name" : "jenkins",
        "api_key" : "${var.cloudflare_api_key}"
      }
    )

  }

  # argocd
  provisioner "file" {
    destination = "/tmp/argocd-secret.yaml"
    content = templatefile(
      "${path.module}/cert/cert-manager-cloudflare-secret.yaml.tpl",
      {
        "name" : "argocd",
        "api_key" : "${var.cloudflare_api_key}"
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