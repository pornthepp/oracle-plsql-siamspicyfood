--------------------------------------------------------
--  DDL for View V_ALL_INVENTORY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SMART_FACTORY_DB"."V_ALL_INVENTORY" ("LOT_ID", "PRODUCT_ID", "LOCATION_ID", "LOT_NO", "QUANTITY", "EXPIRATION_DATE", "RECEIVED_DATE") AS 
  SELECT "LOT_ID","PRODUCT_ID","LOCATION_ID","LOT_NO","QUANTITY","EXPIRATION_DATE","RECEIVED_DATE"
    
FROM inventory
;
