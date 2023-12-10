terraform {
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.81.38"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}


