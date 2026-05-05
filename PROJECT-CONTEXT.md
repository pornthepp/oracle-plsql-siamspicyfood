# Project Context: oracle-plsql-siamspicyfood

## Index

- Goal
- Current State
- Completed Work
- Pending Work
- Key Files
- Conventions and Patterns
- Known Issues and Fixes

## Goal

Oracle SQL/PLSQL project for the SiamSpicyFood inventory domain. It creates schema objects for products, storage locations, inventory lots, transaction history, transaction types, stock reports, near-expiry alerts, and packaged procedures for inventory operations.

## Current State

- Source consists of Oracle export-style `.sql` files in the project root.
- Main schema name in SQL files is `SMART_FACTORY_DB`.
- User asked to prepare files for GitHub upload and write Thai markdown documentation explaining the system functions.
- This directory is currently under a larger Git worktree at `D:\GitHub`; the folder itself was initially untracked from that parent repo.

## Completed Work

- Read the SQL files and identified main tables, views, packages, function, type, sequence, and trigger.
- Added `README.md` in Thai explaining project purpose, installation, table structure, packages, procedures, function, views, business flow, and development notes.
- Added `install_all.sql` to run the SQL files in a practical installation order.
- Added this `PROJECT-CONTEXT.md` for future sessions.
- Initialized this folder as a standalone Git repository on branch `main`.
- Created initial commit `98c504a` with all SQL files and documentation.

## Pending Work

- Confirm GitHub target: use an existing remote URL or create a new GitHub repository.
- Push to GitHub once remote/authentication is available.
- Optional: compile-test against Oracle and adjust install order if the target Oracle version reports object dependency errors.
- Optional: fix SQL naming inconsistencies before production use.

## Key Files

- `README.md`: Thai documentation for GitHub readers.
- `install_all.sql`: SQL*Plus/SQLcl installation entry point.
- `PRODUCTS.sql`, `LOCATIONS.sql`, `INVENTORY.sql`, `TRANSACTIONS.sql`, `TRANSACTION_TYPE.sql`: main table DDL.
- `*_CONSTRAINT.sql`, `*_REFCONSTRAINT.sql`: constraints and foreign keys.
- `*_DATA_TABLE.sql`: sample seed data.
- `PKG_PRODUCT_MASTER.sql`, `PKG_PRODUCT_MASTER_1.sql`: product package spec/body.
- `PKG_LOCATION_MASTER.sql`, `PKG_LOCATION_MASTER_1.sql`: location package spec/body.
- `PKG_TRANSACTION_MASTER.sql`, `PKG_TRANSACTION_MASTER_1.sql`: transaction log package spec/body.
- `PKG_INVENTORY_MASTER.sql`, `PKG_INVENTORY_MASTER_1.sql`: inventory operations package spec/body.
- `V_*.sql`: reporting and lookup views.
- `T_EXPIRY_ROW.sql`, `T_EXPIRY_TABLE.sql`: object/table types used by expiry alert function.
- `FN_GET_EXPIRY_ALERT.sql`: pipelined expiry alert function.
- `TRS_TYPE_SEQ.sql`, `TRG_TRS_TYPE_ID.sql`: transaction type ID sequence and trigger.

## Conventions and Patterns

- SQL uses Oracle-specific syntax, identity columns, editionable objects, and quoted schema-qualified object names.
- Package spec files use the base package name; package body files exported with `_1.sql`.
- Procedure names mix prefixes (`sp_`) and domain names; keep existing names unless doing a deliberate API cleanup.
- Most package procedures do not commit; transaction control is expected from caller/application layer.
- Sample transaction codes include `GR`, `MI`, `MOV`, `DEL`, and `ED`.

## Known Issues and Fixes

- `FN_GET_EXPIRY_ALERT.sql` references `inventory_lot`; current table file is `INVENTORY`. If `inventory_lot` does not exist in the target schema, compile will fail. Fix by changing the function to query `inventory` or by adding a compatibility view named `inventory_lot`.
- `PKG_INVENTORY_MASTER.sp_update_info` logs transaction type `EDIT`, while seed data uses transaction code `ED`. Align codes before enforcing transaction type references.
- Column `CATAGORY` appears to be a misspelling of `CATEGORY`, but it is used consistently in table/package files. Rename only with a coordinated migration.
- Several export files include tablespace/storage clauses. Target databases without `USERS` tablespace or with restricted storage permissions may need simplified DDL.
