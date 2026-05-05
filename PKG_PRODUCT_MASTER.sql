--------------------------------------------------------
--  DDL for Package PKG_PRODUCT_MASTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "SMART_FACTORY_DB"."PKG_PRODUCT_MASTER" IS 
            -- Add Product/Material to database
            PROCEDURE product_insert(p_product_code products.product_code%Type,
                                    p_product_name products.product_name%Type ,
                                    p_uom products.uom%Type,
                                    p_safety_stock products.safety_stock%Type,
                                    p_catagory products.catagory%Type);
            -- Update Product Code                       
            PROCEDURE product_code_update(p_product_id products.product_id%TYPE,
                                    p_product_code products.product_code%TYPE);
            -- Update Product Name                                                 
            PROCEDURE product_name_update(p_product_code products.product_code%TYPE,
                                    p_product_name products.product_name%TYPE);
            -- Update Product UOM                                                
            PROCEDURE product_uom_update(p_product_code products.product_code%TYPE,
                                    p_product_uom products.uom%TYPE);                                    
            -- Update Product Safety Stock                                                
            PROCEDURE safetyStock_update(p_product_code products.product_code%TYPE,
                                    p_safetyStock products.safety_stock%TYPE);      
           -- Update Product Catagory                                                
            PROCEDURE catagory_update(p_product_code products.product_code%TYPE,
                                    p_catagory products.catagory%TYPE);      

END pkg_product_master;

/
