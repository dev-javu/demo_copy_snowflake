variable "organization_name" {
  type        = string
  description = "Organization identifier for the Snowflake account."
}

variable "account_name" {
  type        = string
  description = "Account identifier within the Snowflake organization."
}

variable "admin_user" {
  type        = string
  description = "Username Terraform uses to authenticate against Snowflake."
}

variable "admin_private_key_path" {
  type        = string
  description = "Filesystem path to the PEM encoded private key Terraform uses."
}

variable "admin_role" {
  type        = string
  description = "Snowflake role Terraform uses for operations."
}

variable "warehouse" {
  type        = string
  description = "Snowflake warehouse to use."
}
