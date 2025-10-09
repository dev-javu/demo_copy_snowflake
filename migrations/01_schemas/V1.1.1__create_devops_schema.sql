-- Creates the BASE schema in the environment-specific BRONZE_DEVOPS database
-- Production: BRONZE_DEVOPS.BASE
-- Dev:        BRONZE_DEVOPS_DEV.BASE

CREATE SCHEMA IF NOT EXISTS IDENTIFIER('BRONZE_DEVOPS{{ environment_suffix }}.BASE');

