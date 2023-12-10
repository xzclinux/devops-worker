

provider "tencentcloud" {
  region     = var.region
  secret_id  = var.ak
  secret_key = var.sk
}

data "tencentcloud_images" "my_favorite_image" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "centos 7.9"
}

data "tencentcloud_instance_types" "my_favorite_instance_types" {
  filter {
    name   = "instance-family"
    values = ["S5"]
  }

  cpu_core_count   = 4
  memory_size      = 16
  exclude_sold_out = true
}

data "tencentcloud_availability_zones_by_product" "my_favorite_zones" {
  product = "cvm"
}

// Create VPC resource
resource "tencentcloud_vpc" "app" {
  cidr_block = "10.0.0.0/16"
  name       = "awesome_app_vpc"
}

resource "tencentcloud_subnet" "app" {
  vpc_id            = tencentcloud_vpc.app.id
  availability_zone = data.tencentcloud_availability_zones_by_product.my_favorite_zones.zones.0.name
  name              = "awesome_app_subnet"
  cidr_block        = "10.0.1.0/24"
}

// Create a POSTPAID_BY_HOUR CVM instance
resource "tencentcloud_instance" "cvm_postpaid" {
  instance_name              = "cvm_postpaid01"
  availability_zone          = data.tencentcloud_availability_zones_by_product.my_favorite_zones.zones.0.name
  image_id                   = data.tencentcloud_images.my_favorite_image.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.my_favorite_instance_types.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  system_disk_size           = 50
  allocate_public_ip         = true
  internet_max_bandwidth_out = 100
  hostname                   = "root"
  project_id                 = 0
  vpc_id                     = tencentcloud_vpc.app.id
  subnet_id                  = tencentcloud_subnet.app.id
  count                      = 1
  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  tags = {
    tagKey = "tagValue"
  }
  password = var.password
}


