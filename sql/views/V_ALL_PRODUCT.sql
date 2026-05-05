--------------------------------------------------------
--  DDL for View V_ALL_PRODUCT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SMART_FACTORY_DB"."V_ALL_PRODUCT" ("PRODUCT_ID", "PRODUCT_CODE", "PRODUCT_NAME", "UOM", "SAFETY_STOCK", "CATEGORY") AS 
  SELECT "PRODUCT_ID","PRODUCT_CODE","PRODUCT_NAME","UOM","SAFETY_STOCK","CATEGORY" 
    
FROM products
;
