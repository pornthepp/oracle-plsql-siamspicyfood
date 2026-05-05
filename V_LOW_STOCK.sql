--------------------------------------------------------
--  DDL for View V_LOW_STOCK
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SMART_FACTORY_DB"."V_LOW_STOCK" ("PRODUCT_ID", "PRODUCT_NAME", "SAFETY_STOCK", "TOTAL_QTY") AS 
  SELECT i.product_id , p.product_name,p.safety_stock , SUM(i.quantity) AS total_qty 
FROM inventory i 
INNER JOIN products p
ON i.product_id = p.product_id
GROUP BY i.product_id ,p.product_name , p.safety_stock
HAVING SUM(i.quantity) < safety_stock
;
