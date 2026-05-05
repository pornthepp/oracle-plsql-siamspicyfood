--------------------------------------------------------
--  DDL for View V_ALL_TRANSACTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SMART_FACTORY_DB"."V_ALL_TRANSACTIONS" ("TRS_ID", "TRS_TYPE", "PRODUCT_ID", "LOCATION_ID", "LOT_NO", "TRS_DATE", "REF_NO", "OLD_QUANTITY", "NEW_QUANTITY", "LOG_DETAILS", "CREATE_BY") AS 
  SELECT "TRS_ID","TRS_TYPE","PRODUCT_ID","LOCATION_ID","LOT_NO","TRS_DATE","REF_NO","OLD_QUANTITY","NEW_QUANTITY","LOG_DETAILS","CREATE_BY"
    
FROM transactions
;
