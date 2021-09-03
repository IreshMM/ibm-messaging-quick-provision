resource "ibm_is_vpc" "testacc_vpc" {
    name = "test-vpc"
}

resource "ibm_is_subnet" "testacc_subnet" {
  name            = "testsubnet"
  vpc             = ibm_is_vpc.testacc_vpc.id
  zone            = "us-south-1"
  ipv4_cidr_block = "10.240.0.0/24"
}

resource "ibm_is_instance" "testacc_instance" {
  name    = "testinstance"
  image   = "r006-de4fc543-2ce1-47de-b0b8-b98556a741da"
  profile = "cx2-2x4"

  primary_network_interface {
    name="eth1"
    subnet = ibm_is_subnet.testacc_subnet.id
    primary_ipv4_address = "10.240.0.6"
    security_groups = [ibm_is_security_group.testacc_security_group.id]
  }

  vpc  = ibm_is_vpc.testacc_vpc.id
  zone = "us-south-1"
  keys = ["r006-ffde1f77-73af-4850-8a2d-8285c82fb782"]
  depends_on = [ibm_is_security_group.testacc_security_group]

  //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_is_floating_ip" "testacc_floatingip" {
    name = "testfip1"
    target = ibm_is_instance.testacc_instance.primary_network_interface[0].id
}


resource "ibm_is_security_group" "testacc_security_group" {
    name = "test"
    vpc = ibm_is_vpc.testacc_vpc.id
}

resource "ibm_is_security_group_rule" "testacc_security_group_rule_all" {
    group = ibm_is_security_group.testacc_security_group.id
    direction = "inbound"
    remote = "127.0.0.1"
    depends_on = [ibm_is_security_group.testacc_security_group]
 }