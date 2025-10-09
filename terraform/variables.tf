variable "organization_name" {
  type        = string
  description = "Organization identifier for the Snowflake account."
  default     = "ZTXVMSF"
}

variable "account_name" {
  type        = string
  description = "Account identifier within the Snowflake organization."
  default     = "NM92370"
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
  default     = "ACCOUNTADMIN"
}

variable "warehouse" {
  type        = string
  description = "Default Snowflake warehouse to use."
  default     = "COMPUTE_WH"
}
