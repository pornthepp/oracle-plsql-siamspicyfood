# SiamSpicyFood Oracle PL/SQL Inventory System

โปรเจ็คนี้เป็นชุด Oracle SQL/PLSQL สำหรับสร้างระบบจัดการวัตถุดิบของ SiamSpicyFood โดยเน้นงานคลังสินค้า เช่น สินค้า/วัตถุดิบ, ตำแหน่งจัดเก็บ, lot สินค้า, transaction log, การเบิกแบบ FEFO และรายงานสินค้าใกล้หมดอายุหรือ stock ต่ำ

## สิ่งที่อยู่ในโปรเจ็ค

- ตารางหลัก: `PRODUCTS`, `LOCATIONS`, `INVENTORY`, `TRANSACTIONS`, `TRANSACTION_TYPE`
- Package สำหรับจัดการข้อมูลหลัก: `PKG_PRODUCT_MASTER`, `PKG_LOCATION_MASTER`
- Package สำหรับงานคลังสินค้า: `PKG_INVENTORY_MASTER`
- Package สำหรับบันทึก transaction: `PKG_TRANSACTION_MASTER`
- View สำหรับดูข้อมูลรวมและรายงาน: `V_ALL_*`, `V_LOW_STOCK`, `V_EXPIRATION_ALERT`, `V_INVENTORY_BALANCE_DETAILS`
- Function แบบ pipelined สำหรับแจ้งเตือนวันหมดอายุ: `FN_GET_EXPIRY_ALERT`
- Type สำหรับผลลัพธ์ expiry alert: `T_EXPIRY_ROW`, `T_EXPIRY_TABLE`
- Sequence และ Trigger สำหรับรหัส transaction type: `TRS_TYPE_SEQ`, `TRG_TRS_TYPE_ID`

## โครงสร้างไฟล์

```text
.
├── README.md
├── PROJECT-CONTEXT.md
└── sql/
    ├── tables/       -- table DDL
    ├── constraints/  -- constraints และ foreign keys
    ├── data/         -- sample seed data
    ├── packages/     -- package specs และ package bodies
    ├── views/        -- report/lookup views
    ├── functions/    -- standalone functions
    ├── types/        -- Oracle object/table types
    ├── sequences/    -- sequence DDL
    ├── triggers/     -- trigger DDL
    └── indexes/      -- exported standalone index DDL
```

## การนำไปรันจริง

โปรเจ็คนี้จัดไว้สำหรับแสดง source code และโครงสร้าง Oracle PL/SQL บน GitHub/Resume เป็นหลัก หากต้องการนำไปรันจริง ให้รันไฟล์ SQL ตามลำดับหมวดดังนี้:

1. `sql/tables/`
2. `sql/sequences/` และ `sql/triggers/`
3. `sql/constraints/`
4. `sql/data/`
5. `sql/types/`
6. `sql/packages/`
7. `sql/views/`
8. `sql/functions/`

> หมายเหตุ: ไฟล์ SQL export ระบุ schema เป็น `SMART_FACTORY_DB` ถ้าติดตั้งใน schema อื่นให้แก้ชื่อ schema ในไฟล์ SQL ก่อน

## โครงสร้างข้อมูลหลัก

### PRODUCTS

เก็บข้อมูลสินค้า/วัตถุดิบ เช่น code, name, หน่วยนับ, safety stock และ category

คอลัมน์สำคัญ:

- `PRODUCT_ID`: รหัสสินค้าแบบ identity
- `PRODUCT_CODE`: รหัสสินค้าแบบอ่านง่าย เช่น `RM-001`
- `PRODUCT_NAME`: ชื่อสินค้า/วัตถุดิบ
- `UOM`: หน่วยนับ ค่า default คือ `KG`
- `SAFETY_STOCK`: จำนวนขั้นต่ำที่ต้องมีใน stock
- `CATEGORY`: หมวดหมู่สินค้า

### LOCATIONS

เก็บตำแหน่งจัดเก็บสินค้าในคลัง

- `LOCATION_ID`: รหัสตำแหน่ง
- `LOCATION_CODE`: code ตำแหน่ง เช่น `Z01-A01`
- `DESCRIPTION`: คำอธิบาย zone หรือพื้นที่จัดเก็บ

### INVENTORY

เก็บ stock ราย lot แยกตามสินค้าและตำแหน่ง

- `LOT_ID`: รหัส lot แบบ identity
- `PRODUCT_ID`: อ้างอิงสินค้า
- `LOCATION_ID`: อ้างอิงตำแหน่งจัดเก็บ
- `LOT_NO`: เลข lot
- `QUANTITY`: จำนวนคงเหลือ ต้องไม่ต่ำกว่า 0
- `EXPIRATION_DATE`: วันหมดอายุ
- `RECEIVED_DATE`: วันที่รับเข้า

### TRANSACTIONS

เก็บประวัติความเคลื่อนไหว stock เช่น รับเข้า, แก้ไข, ย้าย, เบิก, ลบ lot ว่าง

- `TRS_TYPE`: ประเภท transaction เช่น `GR`, `MOV`, `MI`, `DEL`
- `OLD_QUANTITY`: จำนวนก่อนทำรายการ
- `NEW_QUANTITY`: จำนวนหลังทำรายการ
- `LOG_DETAILS`: รายละเอียดการทำรายการ
- `CREATE_BY`: ผู้ทำรายการ

### TRANSACTION_TYPE

เก็บ master ของประเภท transaction

- `TRS_TYPE_CODE`: code รายการ เช่น `GR`, `MI`
- `ACTION_TYPE`: ผลกระทบต่อ stock เช่น `1` เพิ่ม, `-1` ลด, `0` ย้าย/ไม่มีผลสุทธิ

## Package และ Function

### PKG_PRODUCT_MASTER

ใช้จัดการข้อมูลสินค้า/วัตถุดิบ

- `product_insert`: เพิ่มสินค้าใหม่ โดยรับ product code, name, uom, safety stock และ category
- `product_code_update`: แก้ไข product code จาก `PRODUCT_ID`
- `product_name_update`: แก้ไขชื่อสินค้าจาก `PRODUCT_CODE`
- `product_uom_update`: แก้ไขหน่วยนับจาก `PRODUCT_CODE`
- `safetyStock_update`: แก้ไข safety stock จาก `PRODUCT_CODE`
- `category_update`: แก้ไข category จาก `PRODUCT_CODE`

ตัวอย่าง:

```sql
BEGIN
  pkg_product_master.product_insert('RM-006', 'Dried Chili', 'KG', 100, 'RAW');
END;
/
```

### PKG_LOCATION_MASTER

ใช้จัดการตำแหน่งจัดเก็บ

- `location_insert`: เพิ่ม location ใหม่
- `location_code_update`: แก้ไข location code จาก `LOCATION_ID`

ตัวอย่าง:

```sql
BEGIN
  pkg_location_master.location_insert('Z03-A01', 'Finished Goods');
END;
/
```

### PKG_TRANSACTION_MASTER

ใช้บันทึกประวัติ transaction ลงตาราง `TRANSACTIONS`

- `sp_create_trs`: เพิ่ม transaction log พร้อมข้อมูลสินค้า, location, lot, วันที่, ref no, จำนวนก่อน/หลัง และรายละเอียด

Package นี้ถูกเรียกจาก `PKG_INVENTORY_MASTER` เพื่อบันทึก log อัตโนมัติหลังรับเข้า, แก้ไข, ย้าย, เบิก หรือ clear lot

### PKG_INVENTORY_MASTER

เป็น package หลักของงานคลังสินค้า

- `sp_receive_goods`: รับสินค้าเข้าคลัง สร้าง row ใน `INVENTORY` และบันทึก transaction type `GR`
- `sp_update_info`: แก้ไขข้อมูล lot เช่น lot no, quantity, expiration date, received date และบันทึก log การเปลี่ยนแปลง
- `sp_inventory_qty_update`: อัปเดตจำนวนคงเหลือของ lot โดยตรง
- `sp_inventory_transfer_product`: ย้ายสินค้าจาก lot หนึ่งไป location ใหม่ พร้อมตรวจจำนวนคงเหลือและบันทึก transaction type `MOV`
- `sp_inventory_clear_empty_lot`: ลบ lot ที่ quantity เป็น 0 และบันทึก transaction type `DEL`
- `sp_issue_inventory_fefo`: เบิกสินค้าตามหลัก FEFO โดยตัด lot ที่หมดอายุก่อนก่อน และบันทึก transaction type `MI`
- `sp_near_exp`: เปิด `SYS_REFCURSOR` คืนรายการสินค้าที่ใกล้หมดอายุภายในจำนวนวันที่กำหนด

ตัวอย่างรับสินค้าเข้า:

```sql
BEGIN
  pkg_inventory_master.sp_receive_goods(
    p_product_id  => 3,
    p_location_id => 22,
    p_lot_no      => 'RM-20260501-001',
    p_quantity    => 50,
    p_exp         => DATE '2026-12-31',
    p_received    => SYSDATE
  );
END;
/
```

ตัวอย่างเบิกสินค้าแบบ FEFO:

```sql
BEGIN
  pkg_inventory_master.sp_issue_inventory_fefo(
    p_product_id => 3,
    p_qty        => 20
  );
END;
/
```

ตัวอย่างย้ายสินค้า:

```sql
BEGIN
  pkg_inventory_master.sp_inventory_transfer_product(
    p_lot_id      => 25,
    p_qty         => 10,
    p_location_id => 41
  );
END;
/
```

### FN_GET_EXPIRY_ALERT

เป็น pipelined function สำหรับคืนรายการสินค้าใกล้หมดอายุ โดยรับจำนวนวัน threshold เช่น 30 วัน แล้วคืนข้อมูลเป็น table function

ผลลัพธ์ประกอบด้วย:

- `PRODUCT_NAME`
- `LOT_NO`
- `LOCATION_CODE`
- `DAYS_LEFT`
- `STATUS`: `Expired`, `CRITICAL`, หรือ `WARNING`

ตัวอย่าง:

```sql
SELECT *
FROM TABLE(fn_get_expiry_alert(30));
```

## Views

- `V_ALL_PRODUCT`: ดูสินค้าทั้งหมด
- `V_ALL_LOCATION`: ดู location ทั้งหมด
- `V_ALL_INVENTORY`: ดู inventory lot ทั้งหมด
- `V_ALL_TRANSACTIONS`: ดู transaction log ทั้งหมด
- `V_ALL_TRANSACTION_TYPE`: ดู transaction type ทั้งหมด
- `V_LOW_STOCK`: แสดงสินค้าที่จำนวนรวมต่ำกว่า safety stock
- `V_EXPIRATION_ALERT`: แสดงสินค้าใกล้หมดอายุ พร้อม status
- `V_INVENTORY_BALANCE_DETAILS`: แสดงรายละเอียด stock ราย lot พร้อมยอดรวมต่อสินค้าและจำนวนวันก่อนหมดอายุ

## Business Flow

1. เพิ่มข้อมูลสินค้าและ location
2. รับสินค้าเข้าคลังด้วย `sp_receive_goods`
3. ดูยอด stock ผ่าน `V_INVENTORY_BALANCE_DETAILS`
4. ย้ายสินค้าได้ด้วย `sp_inventory_transfer_product`
5. เบิกสินค้าแบบ FEFO ด้วย `sp_issue_inventory_fefo`
6. ตรวจ stock ต่ำด้วย `V_LOW_STOCK`
7. ตรวจสินค้าใกล้หมดอายุด้วย `V_EXPIRATION_ALERT` หรือ `FN_GET_EXPIRY_ALERT`
8. ตรวจประวัติการเคลื่อนไหวผ่าน `V_ALL_TRANSACTIONS`
