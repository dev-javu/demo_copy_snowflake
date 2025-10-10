-- Create schema 'base' in BRONZE_DEVOPS (prod) or BRONZE_DEVOPS_DEV (non-prod)
-- Uses Jinja to determine target DB from environment suffix

CREATE SCHEMA IF NOT EXISTS BRONZE_DEVOPS{{ environment_suffix | default('') }}.base;