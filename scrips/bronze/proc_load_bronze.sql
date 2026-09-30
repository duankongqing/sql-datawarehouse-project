/*
================================================================================
脚本名称：proc_load_bronze.sql

功能说明：
    将 CRM 和 ERP 系统的 CSV 源数据加载至 Bronze 层。

处理流程：

    Source System
          |
          | CSV
          v
      Bronze Layer

加载规则：
    1. 全量加载。
    2. 加载前 TRUNCATE 目标表。
    3. 业务字段保持源数据原始格式。
    4. 不在 Bronze 层进行业务清洗和类型转换。
    5. create_date 自动记录数据进入 Bronze 层的时间。
    6. source_system 由加载脚本补充。
    7. 使用显式字段列表，避免技术元数据字段参与 CSV 映射。

加载方式：
    MySQL LOAD DATA LOCAL INFILE
================================================================================
*/

USE bronze;


-- ============================================================
-- CRM 客户信息
-- ============================================================

TRUNCATE TABLE crm_cust_info;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE crm_cust_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    cst_id,
    cst_key,
    cst_first_name,
    cst_last_name,
    cst_material_stauts,
    cst_gndr,
    cst_create_date
);

UPDATE crm_cust_info
SET source_system = 'CRM';


-- ============================================================
-- CRM 产品信息
-- ============================================================

TRUNCATE TABLE crm_prd_info;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
);

UPDATE crm_prd_info
SET source_system = 'CRM';


-- ============================================================
-- CRM 销售明细
-- ============================================================

TRUNCATE TABLE crm_sales_details;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity
);

UPDATE crm_sales_details
SET source_system = 'CRM';


-- ============================================================
-- ERP 客户信息
-- ============================================================

TRUNCATE TABLE erp_cust_az12;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
INTO TABLE erp_cust_az12
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    cid,
    bdate,
    gen
);

UPDATE erp_cust_az12
SET source_system = 'ERP';


-- ============================================================
-- ERP 地区国家信息
-- ============================================================

TRUNCATE TABLE erp_loc_a101;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
INTO TABLE erp_loc_a101
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    cid,
    cntry
);

UPDATE erp_loc_a101
SET source_system = 'ERP';


-- ============================================================
-- ERP 产品分类信息
-- ============================================================

TRUNCATE TABLE erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE erp_px_cat_g1v2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    id,
    cat,
    subcat,
    maintenance
);

UPDATE erp_px_cat_g1v2
SET source_system = 'ERP';
