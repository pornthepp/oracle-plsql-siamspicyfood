--------------------------------------------------------
--  DDL for Trigger TRG_TRS_TYPE_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "SMART_FACTORY_DB"."TRG_TRS_TYPE_ID" 
BEFORE INSERT ON transaction_type 
FOR EACH ROW 
 WHEN (NEW.TRS_TYPE_ID IS NULL) BEGIN
    :NEW.TRS_TYPE_ID := TRS_TYPE_SEQ.NEXTVAL;
END;
/
ALTER TRIGGER "SMART_FACTORY_DB"."TRG_TRS_TYPE_ID" ENABLE;
