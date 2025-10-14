-- Creates schema `MONGODB` in BRONZE with environment suffix.
-- Uses SnowSQL variable substitution for the database suffix only.
-- The workflow sets -D SUFIX=$SNOWFLAKE_ENV_SUFFIX ("_DEV" for dev, empty for production).
-- Examples:
--   dev:        CREATE SCHEMA IF NOT EXISTS BRONZE_DEV.MONGODB;
--   production: CREATE SCHEMA IF NOT EXISTS BRONZE.MONGODB;

CREATE SCHEMA IF NOT EXISTS BRONZE_DEVOPS&{SUFIX}.MONGODB;
