terraform {
  backend "gcs" {
    bucket = "data-terraform"
    prefix = "snowflake/state"
  }
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}
provider "snowflake" {
  organization_name = var.organization_name
  account_name      = var.account_name
  user              = var.admin_user
  private_key       = file(var.admin_private_key_path)
  authenticator     = "SNOWFLAKE_JWT"
  role              = var.admin_role
  warehouse         = var.warehouse
}


resource "snowflake_database" "schemachange" {
  name         = "SCHEMACHANGE"
  is_transient = false
}

resource "snowflake_database" "schemachange_dev" {
  name         = "SCHEMACHANGE_DEV"
  is_transient = false
}

resource "snowflake_database" "bronze_devops" {
  name         = "BRONZE_DEVOPS"
  is_transient = false
}

resource "snowflake_database" "bronze_devops_dev" {
  name         = "BRONZE_DEVOPS_DEV"
  is_transient = false
}

resource "snowflake_database" "silver_devops_dev" {
  name         = "SILVER_DEVOPS_DEV"
  is_transient = false
}

resource "snowflake_database" "silver_devops" {
  name         = "SILVER_DEVOPS"
  is_transient = false
}


############################################
# Databases for bronze / silver / gold
############################################
/*

resource "snowflake_database" "schemachange" {
  name         = "SCHEMACHANGE"
  is_transient = false
}

resource "snowflake_database" "bronze" {
  name         = "BRONZE"
  is_transient = false
}

resource "snowflake_database" "silver" {
  name         = "SILVER"
  is_transient = false
}

resource "snowflake_database" "gold" {
  name         = "GOLD"
  is_transient = false
}

resource "snowflake_database" "bronze_dev" {
  name         = "BRONZE_DEV"
  is_transient = false
}

resource "snowflake_database" "silver_dev" {
  name         = "SILVER_DEV"
  is_transient = false
}

resource "snowflake_database" "gold_dev" {
  name         = "GOLD_DEV"
  is_transient = false
}
*/