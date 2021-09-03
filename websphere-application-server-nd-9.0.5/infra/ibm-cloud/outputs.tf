output "floating_ip" {
    value = ibm_is_floating_ip.testacc_floatingip.address
    description = "Floating IP of the instance"
}
