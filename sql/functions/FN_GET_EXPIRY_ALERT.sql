--------------------------------------------------------
--  DDL for Function FN_GET_EXPIRY_ALERT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "SMART_FACTORY_DB"."FN_GET_EXPIRY_ALERT" (p_days_threshold NUMBER DEFAULT 30 ) RETURN t_expiry_table PIPELINED IS
        BEGIN
                FOR r IN (SELECT p.product_name , i.lot_no,l.location_code, TRUNC(i.expiration_date - SYSDATE) AS day_left
                                FROM inventory i
                                JOIN products p on i.product_id = p.product_id
                                JOIN locations l on l.location_id = i.location_id
                                WHERE TRUNC(i.expiration_date - SYSDATE) <= p_days_threshold) 
                    LOOP
                    -- send data row by row
                        PIPE ROW (t_expiry_row(r.product_name,
                                                            r.lot_no,
                                                            r.location_code,
                                                            r.day_left,
                                                            CASE WHEN r.day_left <=0 THEN 'Expired'
                                                                        WHEN r.day_left <= 10 THEN 'CRITICAL'
                                                                        ELSE 'WARNING' END ));
                    END LOOP;
                    RETURN;
        END;

/
