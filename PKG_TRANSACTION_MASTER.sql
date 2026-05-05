--------------------------------------------------------
--  DDL for Package PKG_TRANSACTION_MASTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "SMART_FACTORY_DB"."PKG_TRANSACTION_MASTER" IS
        PROCEDURE sp_create_trs (p_trs_type transactions.trs_type%TYPE ,
                        p_product_id transactions.product_id%TYPE,
                        p_location_id transactions.location_id%TYPE,
                        p_lot_no transactions.lot_no%TYPE,
                        p_trs_date transactions.trs_date%TYPE,
                        p_ref_no transactions.ref_no%TYPE,
                        p_o_qty transactions.old_quantity%TYPE,
                        p_n_qty transactions.new_quantity%TYPE,
                        p_log_details transactions.log_details%TYPE,
                        p_create_by transactions.create_by%TYPE);
END pkg_transaction_master;

/
