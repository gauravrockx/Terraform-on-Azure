variable "number_of_subnets" {
    type = number
    description = "This defines the number of subnet"
    default = 2
    validation {
      condition = var.number_of_subnets < 5
      error_message = "The number of subnets must be less than 5"
    }
}
variable "number_of_machines" {
    type = number
    description = "This defines the number of machines"
    default = 2
    validation {
        condition = var.number_of_machines < 4
        error_message = "The number of machines must be less than 3"
    }
}