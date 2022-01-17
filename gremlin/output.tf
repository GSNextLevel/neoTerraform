output "security_group_id" {
  value = module.security_group.security_group_id
}

output "public_subnets" {
  value = module.vpc.public_subnets[0]
}
