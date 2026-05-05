--------------------------------------------------------
--  DDL for Package Body PKG_INVENTORY_MASTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SMART_FACTORY_DB"."PKG_INVENTORY_MASTER" IS
        -- =======================================================
        --Insert Material/Product to inventory
        -- =======================================================        
        PROCEDURE sp_receive_goods (p_product_id products.product_id%TYPE,
                p_location_id locations.location_id%TYPE,
                p_lot_no inventory.lot_no%TYPE, 
                p_quantity inventory.quantity%TYPE,
                p_exp inventory.expiration_date%TYPE,
                p_received inventory.received_date%TYPE ) IS
        BEGIN
                INSERT INTO inventory (product_id,location_id,lot_no,quantity,expiration_date,received_date) 
                VALUES (p_product_id,p_location_id,p_lot_no, p_quantity,p_exp,p_received);
                DBMS_OUTPUT.PUT_LINE('Insert Row Success');
                --create transaction log
                pkg_transaction_master.sp_create_trs(p_trs_type=> 'GR',
                                p_product_id => p_product_id, 
                                p_location_id => p_location_id ,
                                p_lot_no => p_lot_no,
                                p_trs_date => SYSDATE,
                                p_ref_no =>'no ref',
                                p_o_qty => 0 ,
                                p_n_qty => p_quantity,
                                p_log_details => 'Goods Received',
                                p_create_by => 'USER');
        EXCEPTION 
                WHEN OTHERS THEN
                        ROLLBACK;
                        RAISE_APPLICATION_ERROR(-20001, 'Error during insert product : '|| SQLERRM);      

        END sp_receive_goods;
        
        
        -- =======================================================        
        --Update Inventory lot (All)
        -- =======================================================        
        PROCEDURE sp_update_info (p_lot_id inventory.lot_id%TYPE,
                p_lot_no inventory.lot_no%TYPE DEFAULT NULL,
                p_quantity inventory.quantity%TYPE DEFAULT NULL,
                p_exp inventory.expiration_date%TYPE DEFAULT NULL,
                p_received inventory.received_date%TYPE DEFAULT NULL ) IS
                
                --old data 
                v_inv_rec inventory%ROWTYPE;
                v_log_details transactions.log_details%TYPE := 'EDIT: ';
        BEGIN
                --get old data
                SELECT  * INTO v_inv_rec FROM inventory WHERE lot_id = p_lot_id;
                --create transaction log 'EDIT'
                IF p_lot_no IS NOT NULL AND p_lot_no != v_inv_rec.lot_no 
                THEN v_log_details := v_log_details || 'LOT: '||v_inv_rec.lot_no ||' -> '||p_lot_no||', ' ; 
                END IF;
                
                IF p_quantity IS NOT NULL AND p_quantity != v_inv_rec.quantity 
                THEN v_log_details  := v_log_details || 'QTY: '||v_inv_rec.quantity ||' -> '||p_quantity||', ' ; 
                END IF;
                
                IF p_exp IS NOT NULL AND p_exp != v_inv_rec.expiration_date 
                THEN v_log_details := v_log_details || 'EXP: '||v_inv_rec.expiration_date ||' -> '||p_exp||', ' ; 
                END IF;
                
                IF p_received IS NOT NULL AND p_received != v_inv_rec.received_date 
                THEN v_log_details := v_log_details || 'RCP: '||v_inv_rec.received_date ||' -> '||p_received||', ' ; 
                END IF;
                
                UPDATE inventory 
                SET   lot_no = NVL(p_lot_no,lot_no),
                        quantity = NVL(p_quantity,quantity),
                        expiration_date = NVL(p_exp,expiration_date),
                        received_date = NVL (p_received,received_date)
                WHERE lot_id = p_lot_id;
                
                --create transaction log 'EDIT'
                pkg_transaction_master.sp_create_trs(p_trs_type=> 'EDIT',
                                p_product_id=> v_inv_rec.product_id, 
                                p_location_id => v_inv_rec.location_id ,
                                p_lot_no=> NVL(p_lot_no, v_inv_rec.lot_no) ,
                                p_trs_date => SYSDATE,
                                p_ref_no =>'no ref',
                                p_o_qty => v_inv_rec.quantity ,
                                p_n_qty => NVL(p_quantity, v_inv_rec.quantity),
                                p_log_details => RTRIM(v_log_details, ', '),
                                p_create_by => 'USER');
        
        EXCEPTION
                WHEN OTHERS THEN
                        ROLLBACK;
                        RAISE_APPLICATION_ERROR(-20001, 'Error during update product : '|| SQLERRM);      
        END sp_update_info;
        
        -- =======================================================       
        --Update Inventory Quantity 
        -- =======================================================        
        PROCEDURE sp_inventory_qty_update (p_lot_id inventory.lot_id%TYPE,
                p_quantity inventory.quantity%TYPE ) IS
        BEGIN
                UPDATE inventory SET quantity = p_quantity 
                WHERE lot_id = p_lot_id;
                
                
        EXCEPTION
                WHEN OTHERS THEN
                        ROLLBACK;
                        RAISE_APPLICATION_ERROR(-20001, 'Error during update product : '|| SQLERRM);                                
        END sp_inventory_qty_update;
        
        -- =======================================================        
        --Move product (Change Product location)
        -- =======================================================        
        PROCEDURE sp_inventory_transfer_product(
                p_lot_id inventory.lot_id%TYPE , 
                p_qty inventory.quantity%TYPE,
                p_location_id inventory.location_id%TYPE) IS
                --variable
                v_inv_rec inventory%ROWTYPE;
                --desination data
                v_dest_lot_count NUMBER;
                --log
                v_log_details transactions.log_details%TYPE := 'LOG';
        BEGIN
                --Get Data & Lock Row
                BEGIN
                        SELECT * 
                        INTO v_inv_rec
                        FROM inventory WHERE lot_id = p_lot_id
                        FOR UPDATE; --Lock Row (ป้องกันคนอื่นแย่งแก้ไขพร้อมกัน)
                EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            RAISE_APPLICATION_ERROR(-20001, 'Error: Not Found Lot ID: ' || p_lot_id);
                END;
                
                -- 2. Validate Stock
                IF p_qty > v_inv_rec.quantity THEN
                    RAISE_APPLICATION_ERROR(-20002, 'Error: Quantity not enough (Quantity: ' || v_inv_rec.quantity || ')');
                ELSIF p_qty <= 0 THEN
                    RAISE_APPLICATION_ERROR(-20003, 'Error: Quantity must be greater than 0');
                END IF;
                
                --Get Destination Data
                SELECT COUNT(*)  INTO v_dest_lot_count  FROM inventory 
                WHERE location_id = p_location_id AND product_id = v_inv_rec.product_id AND lot_no = v_inv_rec.lot_no AND ROWNUM =1;
                
                --Move
                IF v_dest_lot_count = 0 THEN 
                        --no lot row,insert new
                        sp_receive_goods(v_inv_rec.product_id,p_location_id,v_inv_rec.lot_no,p_qty,v_inv_rec.expiration_date,v_inv_rec.received_date);
                ELSE
                        --lot Already Exists
                        UPDATE inventory SET quantity = (quantity + p_qty) 
                        WHERE  product_id = v_inv_rec.product_id AND location_id = p_location_id AND lot_no = v_inv_rec.lot_no ;
                END IF;
                --UpdateStock
                sp_inventory_qty_update(p_lot_id,(v_inv_rec.quantity - p_qty));
                DBMS_OUTPUT.PUT_LINE( 'Product Id:' ||v_inv_rec.product_id|| ' Quantity: '||p_qty ||' From '|| v_inv_rec.location_id|| ' Moved To '|| p_location_id   );
                --create transaction log 'MOV'
                v_log_details := 'MOVE ' || v_inv_rec.product_id || ' QTY: '||p_qty||' FROM: '||v_inv_rec.location_id||' -> ' ||p_location_id;
                pkg_transaction_master.sp_create_trs( p_trs_type=> 'MOV',
                                p_product_id=> v_inv_rec.product_id, 
                                p_location_id => v_inv_rec.location_id ,
                                p_lot_no=> v_inv_rec.lot_no ,
                                p_trs_date => SYSDATE,
                                p_ref_no =>'MOV_REF',
                                p_o_qty => v_inv_rec.quantity ,
                                p_n_qty => (v_inv_rec.quantity - p_qty),
                                p_log_details => v_log_details,
                                p_create_by => 'USER');
                                
        EXCEPTION
                WHEN OTHERS THEN
                        ROLLBACK;
                        RAISE_APPLICATION_ERROR(-20001, 'Error during transfer product : '|| SQLERRM);                                
        END sp_inventory_transfer_product;
        
        -- =======================================================        
        --Remove zoro quantity
        -- =======================================================        
        PROCEDURE sp_inventory_clear_empty_lot  IS
                v_log_details transactions.log_details%TYPE;
        BEGIN
                --loop for get data
                FOR inv_rec IN (SELECT *  FROM inventory WHERE quantity = 0 FOR UPDATE) LOOP
                        v_log_details := 'Delete empty lot. Product: '  || inv_rec.product_id || ' From loc: '|| inv_rec.location_id || ' Lot no: '|| inv_rec.lot_no;
                        
                        --create transaction log 'DEL'
                        pkg_transaction_master.sp_create_trs(p_trs_type => 'DEL',
                                p_product_id => inv_rec.product_id,
                                p_location_id => inv_rec.location_id,
                                p_lot_no => inv_rec.lot_no,
                                p_trs_date => SYSDATE,
                                p_ref_no => ' - ',
                                p_o_qty => inv_rec.quantity,
                                p_n_qty => 0,
                                p_log_details => v_log_details,
                                p_create_by => 'USER');
                                
                        DELETE FROM inventory WHERE lot_id = inv_rec.lot_id;
                END LOOP;
        EXCEPTION
                WHEN OTHERS THEN
                        ROLLBACK;                
                        RAISE_APPLICATION_ERROR(-20004, 'Error during inventory cleanup: '|| SQLERRM);
        END sp_inventory_clear_empty_lot;
        
       
        -- =======================================================
        -- Procedure: Issue Inventory FEFO
        -- =======================================================
        PROCEDURE sp_issue_inventory_fefo (p_product_id products.product_id%TYPE,
                p_qty inventory.quantity%TYPE)IS
                --cursor for get product from inventory by product id 
                CURSOR c_inv_fefo IS
                    SELECT * FROM inventory
                    WHERE product_id = p_product_id AND quantity > 0 
                    ORDER BY expiration_date
                    FOR UPDATE;
                    
                v_qty_remaining inventory.quantity%TYPE; --value in need
                v_qty_take inventory.quantity%TYPE; --value to take from lot no
                v_total inventory.quantity%TYPE; 
                v_log_details transactions.log_details%TYPE;
                
        BEGIN
                SELECT NVL(SUM(quantity), 0) INTO v_total FROM inventory  WHERE product_id = p_product_id ;
                IF v_total < p_qty THEN
                    RAISE_APPLICATION_ERROR(-20001,'quantity is not enough for material issue');
                END IF;
                --set start remaining value
                v_qty_remaining := p_qty; --60 | 10
                FOR v_inv_rec IN c_inv_fefo LOOP
                    v_qty_take := LEAST(v_qty_remaining,v_inv_rec.quantity); -- (60 , 50) = 50 | (10,70) = 10
                    --update lot 
                    sp_inventory_qty_update(v_inv_rec.lot_id, (v_inv_rec.quantity - v_qty_take));
                     --create transaction log 'MI' (Material Issue)
                    v_log_details := 'Material Issue ' || p_product_id || ' QTY: '||v_qty_take||' FROM LOT ID: '||v_inv_rec.lot_id||' LOT NO: '||v_inv_rec.lot_no;
                    pkg_transaction_master.sp_create_trs( p_trs_type=> 'MI',
                                p_product_id=> p_product_id, 
                                p_location_id => v_inv_rec.location_id ,
                                p_lot_no=> v_inv_rec.lot_no ,
                                p_trs_date => SYSDATE,
                                p_ref_no =>'MI_REF',
                                p_o_qty => v_inv_rec.quantity ,
                                p_n_qty => (v_inv_rec.quantity - v_qty_take), -- quantity - take (50-50 = 0)
                                p_log_details => v_log_details,
                                p_create_by => 'USER');                             
                    v_qty_remaining := (v_qty_remaining - v_qty_take); -- (60 - 50) = 10 | (10 - 10) = 0
                    EXIT WHEN v_qty_remaining = 0 ;
                END LOOP;

                --check taking enough
                IF v_qty_remaining = 0 THEN
                        DBMS_OUTPUT.PUT_LINE('Product id: ' || p_product_id||' has Disbursed. ');
                ELSE 
                        ROLLBACK;   
                        RAISE_APPLICATION_ERROR(-20002, 'Transaction Failed: Quantity not enough during processing (Remaining: ' || v_qty_remaining || ')');
                END IF;  
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK; 
                RAISE;        
        END sp_issue_inventory_fefo;
        
        -- =======================================================
        --Check near expirate
        -- =======================================================     
        PROCEDURE sp_near_exp (p_days NUMBER DEFAULT 30,
                        c_near_exp OUT SYS_REFCURSOR
                    ) IS

        BEGIN
                OPEN c_near_exp FOR
                        SELECT product_id, lot_no, quantity,expiration_date FROM inventory 
                        WHERE quantity > 0  AND expiration_date BETWEEN SYSDATE AND (SYSDATE + p_days); 
                        
        EXCEPTION
            WHEN OTHERS THEN
                    IF c_near_exp%ISOPEN THEN CLOSE c_near_exp;
                    END IF;    
                    RAISE_APPLICATION_ERROR(-20001, 'Error fetching near-expiry products: ' || SQLERRM);
        END sp_near_exp;

END pkg_inventory_master;

/
