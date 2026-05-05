# Project Context: oracle-plsql-siamspicyfood

## Goal

Resume/GitHub showcase repository for an Oracle SQL/PLSQL inventory system for SiamSpicyFood. The project demonstrates schema design, PL/SQL packages, views, pipelined functions, triggers, seed data, and inventory business logic.

## Current State

- Standalone Git repository on branch `main`.
- SQL files are organized under `sql/` by Oracle object type.
- `README.md` is Thai documentation for GitHub/resume readers.
- No install script is kept because the user wants readable showcase code rather than a deployment package.

## Completed Work

- Organized SQL files into `sql/tables`, `sql/constraints`, `sql/data`, `sql/packages`, `sql/views`, `sql/functions`, `sql/types`, `sql/sequences`, `sql/triggers`, and `sql/indexes`.
- Documented tables, packages, functions, views, and business flow in Thai.
- Standardized product category naming to `CATEGORY`/`category` across DDL, constraints, seed data, view, package spec/body, and README.
- Fixed `FN_GET_EXPIRY_ALERT` to query `inventory`.
- Standardized edit transaction type seed data to `EDIT` to match `PKG_INVENTORY_MASTER.sp_update_info`.

## Pending Work

- User will handle GitHub upload/push.
- Optional: compile all objects in Oracle to catch environment-specific export issues such as tablespace/storage clauses.
- Optional: improve PL/SQL error handling and naming style if converting from showcase code to production code.

## Key Files

- `README.md`: Thai GitHub/resume documentation.
- `sql/tables/`: main table DDL.
- `sql/constraints/`: table constraints and foreign keys.
- `sql/data/`: sample seed data.
- `sql/packages/`: package specs and package bodies.
- `sql/views/`: reporting and lookup views.
- `sql/functions/FN_GET_EXPIRY_ALERT.sql`: pipelined expiry alert function.
- `sql/types/`: object/table types for expiry alert output.
- `sql/sequences/`, `sql/triggers/`, `sql/indexes/`: supporting database objects.

## Conventions and Patterns

- Oracle object files use export-style SQL and schema-qualified names with schema `SMART_FACTORY_DB`.
- Table/column names are uppercase in DDL; PL/SQL references use normal unquoted identifiers.
- Package body files use `_1.sql` suffix from the original export.
- Package procedures generally do not commit; caller/application controls commit/rollback.
- Product category naming is standardized as `CATEGORY` column and `category_update` procedure.

## Known Issues and Fixes

- Fixed product category column/API naming.
- Fixed expiry alert function table reference to `inventory`.
- Fixed transaction type mismatch from `ED` to `EDIT`.
- Remaining portability risk: exported DDL includes tablespace/storage clauses that may need cleanup for other Oracle environments.
