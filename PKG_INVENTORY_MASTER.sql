--------------------------------------------------------
--  DDL for Package PKG_INVENTORY_MASTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "SMART_FACTORY_DB"."PKG_INVENTORY_MASTER" IS
        --Insert Material/Product to inventory
        PROCEDURE sp_receive_goods (p_product_id products.product_id%TYPE,
                p_location_id locations.location_id%TYPE,
                p_lot_no inventory.lot_no%TYPE,
                p_quantity inventory.quantity%TYPE,
                p_exp inventory.expiration_date%TYPE,
                p_received inventory.received_date%TYPE );
                
        --Update Inventory lot (All)
        PROCEDURE sp_update_info (p_lot_id inventory.lot_id%TYPE,
                p_lot_no inventory.lot_no%TYPE DEFAULT NULL,
                p_quantity inventory.quantity%TYPE DEFAULT NULL,
                p_exp inventory.expiration_date%TYPE DEFAULT NULL,
                p_received inventory.received_date%TYPE DEFAULT NULL );
        --Update Inventory Quantity 
        PROCEDURE sp_inventory_qty_update (p_lot_id inventory.lot_id%TYPE,
                p_quantity inventory.quantity%TYPE );
                
        --Move product (Change Product location)
        PROCEDURE sp_inventory_transfer_product(p_lot_id inventory.lot_id%TYPE , 
                p_qty inventory.quantity%TYPE , 
                p_location_id inventory.location_id%TYPE);
        --Remove zoro quantity
        PROCEDURE sp_inventory_clear_empty_lot ;
        --Disbursement system
        PROCEDURE sp_issue_inventory_fefo (p_product_id products.product_id%TYPE,
                p_qty inventory.quantity%TYPE);
        --Check near expirate        
        PROCEDURE sp_near_exp (p_days NUMBER DEFAULT 30,c_near_exp OUT SYS_REFCURSOR);
END pkg_inventory_master;

/
