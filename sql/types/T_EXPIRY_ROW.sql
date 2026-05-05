--------------------------------------------------------
--  DDL for Type T_EXPIRY_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "SMART_FACTORY_DB"."T_EXPIRY_ROW" AS OBJECT (
        product_name VARCHAR2(50),
        lot_no VARCHAR2(50),
        location_code VARCHAR2(20),
        days_left NUMBER,
        status VARCHAR2(20));

/
