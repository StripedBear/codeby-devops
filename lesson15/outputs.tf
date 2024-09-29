output "subnets_info" {
  value = module.data_subnet.subnets_details
}

output "vm_instance_ip" {
  value = module.vm.vm_ip_address
}