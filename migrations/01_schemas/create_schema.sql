-- Script to create the "DATA" schema in the database
-- Uses fixed base DB 'BRONZE_DEVOPS' and the suffix as provided by the CLI

-- Create DATA schema in target DB without changing session database 
CREATE SCHEMA IF NOT EXISTS {{ 'BRONZE_DEVOPS' ~ (variables.ENV_SUFFIX | default('')) }}.DATA;
