# demo_snowflake

CI/CD for this project provisions Snowflake infrastructure with Terraform and applies SQL migrations using the Snowflake CLI. Deployments are branch-driven and rely on a Jinja environment suffix to target dev vs. production.

**At a glance**
- Branches: `dev` (development) and `production` (production)
- Validate workflow (dry run) on Pull Requests to `dev`/`production`
- Deploy workflow (executes) on pushes to `dev`/`production`
- SQL templating: Jinja with `ENV_SUFFIX` (e.g., `_DEV` for `dev`, empty for `production`)
- Terraform runs only when files under `terraform/` change
- SQL migrations run only when files under `migrations/**` change

## Branches and Environments
- `dev` branch
  - Uses development database and `ENV_SUFFIX=_DEV`
  - Example schema name: `BRONZE_DEVOPS_DEV`
- `production` branch
  - Uses production database and `ENV_SUFFIX=` (empty)
  - Example schema name: `BRONZE_DEVOPS`

The suffix is injected into SQL via Jinja templating. For instance, the following SQL:

```
CREATE SCHEMA IF NOT EXISTS BRONZE_DEVOPS{{ ENV_SUFFIX }}.DATA;
```

Evaluates to:
- On `dev`: `CREATE SCHEMA IF NOT EXISTS BRONZE_DEVOPS_DEV.DATA;`
- On `production`: `CREATE SCHEMA IF NOT EXISTS BRONZE_DEVOPS.DATA;`

## Workflows
There are two GitHub Actions that both use a common workflow:
- `.github/workflows/validate.yml`: runs on pull requests to `dev` and `production` with `dry_run: true`.
- `.github/workflows/deploy.yml`: runs on push to `dev` and `production` with `dry_run: false`.

The core logic lives in `.github/workflows/_base.yml`:
- Detects which folders changed (`migrations/**`, `terraform/**`).
- Selects environment based on the effective branch (PR target or the pushed branch).
  - Sets `SNOWFLAKE_DATABASE` to the dev or prod database secret.
  - Sets `SNOWFLAKE_ENV_SUFFIX` to `_DEV` for `dev` or empty for `production`.
- Executes SQL using the Snowflake CLI with Jinja templating enabled and variables passed in:

```
snow sql \
  --enable-templating JINJA \
  --database "$SNOWFLAKE_DATABASE" \
  --variable ENV_SUFFIX="$SNOWFLAKE_ENV_SUFFIX" \
  -f path/to/script.sql
```

Terraform is initialized, validated, planned (and applied on deploy) only when files under `terraform/` change.

## Writing Migrations (Jinja)
Author SQL under `migrations/` using Jinja variables. The project provides `ENV_SUFFIX` which will be `_DEV` (dev) or empty (production). Example:

```
-- migrations/01_schemas/create_schema.sql
CREATE SCHEMA IF NOT EXISTS BRONZE_DEVOPS{{ ENV_SUFFIX }}.DATA;
```

You can use the same pattern in tables, views, procedures, or tasks to keep environment-specific naming consistent.

Folder order (applied in numeric order when changed):
- `migrations/01_schemas`
- `migrations/02_tables`
- `migrations/03_views`
- `migrations/04_procedures`
- `migrations/05_tasks`

## Terraform
The `terraform/` module configures Snowflake (provider auth via key pair). Example resources include databases for both environments (e.g., `BRONZE_DEVOPS`, `BRONZE_DEVOPS_DEV`). Terraform steps run only when `terraform/**` changes.

## Required Secrets
Store these in the repository or organization GitHub Actions secrets:
- `GCP_CREDENTIALS` (JSON) — used by the Terraform backend step (GCS)
- `SF_ORGANIZATION_NAME` — Terraform Snowflake provider
- `SF_ACCOUNT_NAME` — Terraform Snowflake provider
- `SF_USERNAME` — Snowflake user (Terraform and Snow CLI)
- `SF_PRIVATE_KEY_B64` — base64-encoded private key for key pair auth
- `SF_ROLE` — Snowflake role
- `SF_WAREHOUSE` — Snowflake warehouse
- `SF_ACCOUNT` — Snowflake account locator (used by Snow CLI)
- `SF_DATABASE` — Production database name (Snow CLI)
- `SF_DATABASE_DEV` — Development database name (Snow CLI)

Note: Terraform uses `SF_ACCOUNT_NAME`, while the Snow CLI job uses `SF_ACCOUNT`. Both must be configured appropriately for your Snowflake account.

## Typical Flow
1) Open PR to `dev`: Validate (dry run) runs. Review logs and SQL that would execute.
2) Merge to `dev`: Deploy runs. SQL executes against the dev database with `_DEV` suffix.
3) Open PR to `production`: Validate (dry run) runs using production settings.
4) Merge to `production`: Deploy runs to production (no suffix).

