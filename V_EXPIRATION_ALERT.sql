--------------------------------------------------------
--  DDL for View V_EXPIRATION_ALERT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SMART_FACTORY_DB"."V_EXPIRATION_ALERT" ("PRODUCT_NAME", "PRODUCT_ID", "LOT_NO", "LOCATION_CODE", "EXPIRATION_DATE", "DATE_NOW", "DATE_LEFT", "STATUS") AS 
  SELECT p.product_name ,i.product_id, i.lot_no , l.location_code ,i.expiration_date,SYSDATE AS date_now,(TRUNC(i.expiration_date - SYSDATE)) AS DATE_LEFT ,
    CASE  WHEN (i.expiration_date - SYSDATE) <= 0 THEN 'EXPIRED'  
                WHEN (i.expiration_date - SYSDATE) <=10 THEN 'CRITICAL'
                ELSE 'WARNING'  END AS STATUS
    FROM inventory i
    JOIN products p ON p.product_id = i.product_id 
    JOIN locations  l on i.location_id = l.location_id
    WHERE (TRUNC(i.expiration_date - SYSDATE)) < 30
    ORDER BY date_left ASC
;
