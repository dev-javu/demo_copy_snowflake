-- Script to create the "DATA" schema in the database
-- "BRONZE_DEVOPS" or "BRONZE_DEVOPS_<SUFFIX>" depending on the suffix

-- Base database (can come from `DATABASE`; defaults to BRONZE_DEVOPS)
SET BASE_DB = UPPER('{{ variables.DATABASE | default("BRONZE_DEVOPS") }}');

-- Suffix comes from the `ENV_SUFFIX` variable provided by the CLI
SET SUFFIX_RAW = '{{ variables.ENV_SUFFIX | default("") }}';

-- Normalize: trim leading/trailing underscores and uppercase
SET SUFFIX = UPPER(LTRIM(RTRIM($SUFFIX_RAW, '_'), '_'));

-- Determine target database based on the suffix
SET TARGET_DB = (
  SELECT IFF($SUFFIX IS NULL OR $SUFFIX = '',
             $BASE_DB,
             $BASE_DB || '_' || $SUFFIX)
);

-- Create the database if needed, use it, and create the DATA schema
CREATE DATABASE IF NOT EXISTS IDENTIFIER($TARGET_DB);
USE DATABASE IDENTIFIER($TARGET_DB);
CREATE SCHEMA IF NOT EXISTS DATA;
