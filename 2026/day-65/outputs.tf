output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.my_instance.id
}

output "instance_public_ip" {
  description = "The public ip of the instance"
  value       = aws_instance.my_instance.public_ip
}

output "instance_private_ip" {
  description = "The private ip of the instance"
  value       = aws_instance.my_instance.private_ip
}

