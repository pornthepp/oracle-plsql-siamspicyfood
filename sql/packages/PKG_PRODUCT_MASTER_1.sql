--------------------------------------------------------
--  DDL for Package Body PKG_PRODUCT_MASTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SMART_FACTORY_DB"."PKG_PRODUCT_MASTER" AS
            --Add Product/Material to database
            PROCEDURE product_insert(p_product_code products.product_code%Type ,
                                    p_product_name products.product_name%Type,
                                    p_uom products.uom%Type,
                                    p_safety_stock products.safety_stock%Type,
                                    p_category products.category%Type ) IS
            BEGIN
                INSERT INTO products(product_name,
                                product_code,
                                uom,
                                safety_stock,
                                category)
                VALUES(p_product_name,
                        p_product_code,
                        p_uom,
                        p_safety_stock,
                        p_category);
            END product_insert;
    
            -- Update Product Code                       
            PROCEDURE product_code_update(p_product_id products.product_id%TYPE,
                                    p_product_code products.product_code%TYPE) IS
            BEGIN
                    UPDATE products SET product_code = p_product_code WHERE product_id = p_product_id;
            END product_code_update;
            
            -- Update Product Name                                                 
            PROCEDURE product_name_update(p_product_code products.product_code%TYPE,
                                    p_product_name products.product_name%TYPE) IS
            BEGIN
                     UPDATE products SET product_name = p_product_name WHERE product_code = p_product_code;
            END product_name_update;
            
        
            -- Update Product UOM                                                
            PROCEDURE product_uom_update(p_product_code products.product_code%TYPE,
                                    p_product_uom products.uom%TYPE) IS
            BEGIN
                        UPDATE products SET uom = p_product_uom WHERE product_code = p_product_code;
            END product_uom_update;
            
            -- Update Product Safety Stock
            PROCEDURE safetyStock_update(p_product_code products.product_code%TYPE,
                                    p_safetyStock products.safety_stock%TYPE) IS
            BEGIN
                    UPDATE products SET safety_stock = p_safetyStock WHERE product_code = p_product_code;
            END safetyStock_update;
            
           -- Update Product Category
            PROCEDURE category_update(p_product_code products.product_code%TYPE,
                                    p_category products.category%TYPE) IS
            BEGIN
                    UPDATE products SET category = p_category WHERE product_code = p_product_code;
            END category_update;

END PKG_PRODUCT_MASTER;

/
