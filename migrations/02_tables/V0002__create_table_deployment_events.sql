CREATE TABLE IF NOT EXISTS BRONZE_DEVOPS{{ environment_suffix | default('') }}.base.deployment_events (
  id NUMBER AUTOINCREMENT START 1 INCREMENT 1,
  event_time TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
  service STRING,
  environment STRING,
  status STRING,
  details VARIANT,
  PRIMARY KEY (id)
);

