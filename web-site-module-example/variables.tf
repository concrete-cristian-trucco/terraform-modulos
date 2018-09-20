
variable "name" {
  description = "The name for the resource"
  default = "example"
}
variable "environment" {
  description = "The env of the app"
  default = "staging"
}
variable "subnets" {
  description = "Its a list of subnets ids"
  default = "subnet-d08c7cee"
}
variable "vpc_id" {
  description = "ID of VPC being used"
  default = "vpc-c3ee18b9"
}
