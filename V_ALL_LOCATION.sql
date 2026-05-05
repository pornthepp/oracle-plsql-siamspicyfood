--------------------------------------------------------
--  DDL for View V_ALL_LOCATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SMART_FACTORY_DB"."V_ALL_LOCATION" ("LOCATION_ID", "LOCATION_CODE", "DESCRIPTION") AS 
  SELECT "LOCATION_ID","LOCATION_CODE","DESCRIPTION"
    
FROM locations
;
