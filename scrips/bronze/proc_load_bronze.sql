/*
================================================================================
脚本名称：proc_load_bronze.sql

功能说明：
    将 CRM 和 ERP 系统的 CSV 源数据加载至 Bronze 层。

处理流程：
    Source System -> CSV -> Bronze Layer (使用 NULLIF 安全过滤空字符串)

加载规则：
    1. 全量加载。
    2. 加载前 TRUNCATE 目标表。
    3. 使用 VARCHAR 接收，并通过 NULLIF 将空串转为 NULL，拒绝隐式污染。
    4. source_system 在加载时直接补充。
================================================================================
*/

USE bronze;


-- =========================================================
-- CRM: Customer
-- =========================================================

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
    @v_cst_id,
    @v_cst_key,
    @v_cst_first_name,
    @v_cst_last_name,
    @v_cst_material_stauts,
    @v_cst_gndr,
    @v_cst_create_date
)
SET 
    cst_id              = NULLIF(TRIM(@v_cst_id), ''),
    cst_key             = NULLIF(TRIM(@v_cst_key), ''),
    cst_first_name      = NULLIF(TRIM(@v_cst_first_name), ''),
    cst_last_name       = NULLIF(TRIM(@v_cst_last_name), ''),
    cst_material_stauts = NULLIF(TRIM(@v_cst_material_stauts), ''),
    cst_gndr            = NULLIF(TRIM(@v_cst_gndr), ''),
    cst_create_date     = NULLIF(TRIM(@v_cst_create_date), ''),
    source_system       = 'CRM';


-- =========================================================
-- CRM: Product
-- =========================================================

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
    @v_prd_id,
    @v_prd_key,
    @v_prd_nm,
    @v_prd_cost,
    @v_prd_line,
    @v_prd_start_dt,
    @v_prd_end_dt
)
SET 
    prd_id         = NULLIF(TRIM(@v_prd_id), ''),
    prd_key        = NULLIF(TRIM(@v_prd_key), ''),
    prd_nm         = NULLIF(TRIM(@v_prd_nm), ''),
    prd_cost       = NULLIF(TRIM(@v_prd_cost), ''),
    prd_line       = NULLIF(TRIM(@v_prd_line), ''),
    prd_start_dt   = NULLIF(TRIM(@v_prd_start_dt), ''),
    prd_end_dt     = NULLIF(TRIM(@v_prd_end_dt), ''),
    source_system  = 'CRM';


-- =========================================================
-- CRM: Sales Details
-- =========================================================

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
    @v_sls_ord_num,
    @v_sls_prd_key,
    @v_sls_cust_id,
    @v_sls_order_dt,
    @v_sls_ship_dt,
    @v_sls_due_dt,
    @v_sls_sales,
    @v_sls_quantity,
    @v_sls_price
)
SET 
    sls_ord_num    = NULLIF(TRIM(@v_sls_ord_num), ''),
    sls_prd_key    = NULLIF(TRIM(@v_sls_prd_key), ''),
    sls_cust_id    = NULLIF(TRIM(@v_sls_cust_id), ''),
    sls_order_dt   = NULLIF(TRIM(@v_sls_order_dt), ''),
    sls_ship_dt    = NULLIF(TRIM(@v_sls_ship_dt), ''),
    sls_due_dt     = NULLIF(TRIM(@v_sls_due_dt), ''),
    sls_sales      = NULLIF(TRIM(@v_sls_sales), ''),
    sls_quantity   = NULLIF(TRIM(@v_sls_quantity), ''),
    sls_price      = NULLIF(TRIM(@v_sls_price), ''),
    source_system  = 'CRM';


-- =========================================================
-- ERP: Customer
-- =========================================================

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
    @v_cid,
    @v_bdate,
    @v_gen
)
SET 
    cid            = NULLIF(TRIM(@v_cid), ''),
    bdate          = NULLIF(TRIM(@v_bdate), ''),
    gen            = NULLIF(TRIM(@v_gen), ''),
    source_system  = 'ERP';


-- =========================================================
-- ERP: Location
-- =========================================================

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
    @v_cid,
    @v_cntry
)
SET 
    cid            = NULLIF(TRIM(@v_cid), ''),
    cntry          = NULLIF(TRIM(@v_cntry), ''),
    source_system  = 'ERP';


-- =========================================================
-- ERP: Product Category
-- =========================================================

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
    @v_id,
    @v_cat,
    @v_subcat,
    @v_maintenance
)
SET 
    id             = NULLIF(TRIM(@v_id), ''),
    cat            = NULLIF(TRIM(@v_cat), ''),
    subcat         = NULLIF(TRIM(@v_subcat), ''),
    maintenance    = NULLIF(TRIM(@v_maintenance), ''),
    source_system  = 'ERP';
