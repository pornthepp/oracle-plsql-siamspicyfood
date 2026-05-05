--------------------------------------------------------
--  DDL for View V_INVENTORY_BALANCE_DETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SMART_FACTORY_DB"."V_INVENTORY_BALANCE_DETAILS" ("PRODUCT_NAME", "PRODUCT_ID", "LOT_ID", "LOT_NO", "QUANTITY", "TOTAL", "RECEIVED_DATE", "EXPIRATION_DATE", "EXP_IN") AS 
  SELECT p.product_name,i.product_id,i.lot_id, i.lot_no, i.quantity,(SELECT SUM(quantity) FROM inventory WHERE product_id = i.product_id) AS TOTAL,
i.received_date, i.expiration_date,(TRUNC(i.expiration_date - SYSDATE)) AS exp_in 
FROM inventory i
INNER JOIN products p 
ON p.product_id = i.product_id
ORDER BY i.product_id ASC
;
