--------------------------------------------------------
--  DDL for Package Body PKG_TRANSACTION_MASTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SMART_FACTORY_DB"."PKG_TRANSACTION_MASTER" IS
        PROCEDURE sp_create_trs (p_trs_type transactions.trs_type%TYPE ,
                        p_product_id transactions.product_id%TYPE,
                        p_location_id transactions.location_id%TYPE,
                        p_lot_no transactions.lot_no%TYPE,
                        p_trs_date transactions.trs_date%TYPE,
                        p_ref_no transactions.ref_no%TYPE,
                        p_o_qty transactions.old_quantity%TYPE,
                        p_n_qty transactions.new_quantity%TYPE,
                        p_log_details transactions.log_details%TYPE,
                        p_create_by transactions.create_by%TYPE) IS

        BEGIN
                    INSERT INTO transactions(trs_type, product_id, location_id, lot_no, trs_date, ref_no ,old_quantity,new_quantity,log_details, create_by) 
                    VALUES (p_trs_type,p_product_id, p_location_id, p_lot_no, p_trs_date, p_ref_no,p_o_qty, p_n_qty,p_log_details,p_create_by);
        END sp_create_trs;
END pkg_transaction_master;

/
