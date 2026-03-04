output "nexus_public_ip" {
  value = aws_instance.Nexus.public_ip
}

output "docker_public_ip" {
  value = aws_instance.DockerHost.public_ip

}

output "docker_private_ip" {
  value = aws_instance.DockerHost.private_ip
}

output "ansible_public_ip" {
  value = aws_instance.Ansible-Controller.public_ip
}