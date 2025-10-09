-- Creates the DEVOPS schema in the environment-specific BRONZE_DEVOPS database
-- Production: BRONZE_DEVOPS.DEVOPS
-- Dev:        BRONZE_DEVOPS_DEV.DEVOPS 

CREATE SCHEMA IF NOT EXISTS IDENTIFIER('BRONZE_DEVOPS{{ environment_suffix }}.DEVOPS');

