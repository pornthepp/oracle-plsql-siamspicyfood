--------------------------------------------------------
--  Ref Constraints for Table INVENTORY
--------------------------------------------------------

  ALTER TABLE "SMART_FACTORY_DB"."INVENTORY" ADD FOREIGN KEY ("PRODUCT_ID")
	  REFERENCES "SMART_FACTORY_DB"."PRODUCTS" ("PRODUCT_ID") ENABLE;
  ALTER TABLE "SMART_FACTORY_DB"."INVENTORY" ADD FOREIGN KEY ("LOCATION_ID")
	  REFERENCES "SMART_FACTORY_DB"."LOCATIONS" ("LOCATION_ID") ENABLE;
