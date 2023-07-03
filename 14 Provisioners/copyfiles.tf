resource "null_resource" "addfiles" {
  provisioner "file" {
    source = "Default.html"
    destination = "/var/www/html/Default.html"

    connection {
      type="ssh"
      user="adminuser"
      password = "Azure@007"
      host = "${azurerm_public_ip.appip.ip_address}"
    }
  }
  depends_on = [ azurerm_linux_virtual_machine.Linuxvm ]
}