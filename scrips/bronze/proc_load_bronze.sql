/*
================================================================================
脚本名称：proc_load_bronze.sql
功能说明：
    将 CRM 和 ERP 系统的 CSV 源数据全量加载至 Bronze 层。
处理流程：
    CSV 源文件 → 字符串读取 → TRIM 去空格 → NULLIF 空串转NULL → Bronze 表
加载规则：
    1. 全量加载，加载前 TRUNCATE 清空目标表。
    2. 全部以字符串形式接收，避免隐式类型转换丢失原始数据。
    3. 使用 NULLIF + TRIM 统一空值语义，将空字符串转为数据库 NULL。
    4. source_system 加载时直接赋值，标记数据来源。
    5. 单表执行耗时统计，用于性能观测与链路排查。
前置条件：
    1. MySQL 服务端开启 local_infile 参数。
    2. 客户端连接（DataGrip）勾选 Allow local infile 选项。
    3. 先执行 ddl_bronze.sql 完成表结构创建。
================================================================================
*/

USE bronze;

-- =========================================================
-- CRM: 客户信息表加载
-- =========================================================
SET @cust_start = NOW();
SELECT '>> Loading bronze.crm_cust_info' AS msg;

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
    @v_cst_marital_status,
    @v_cst_gndr,
    @v_cst_create_date
)
SET 
    cst_id              = NULLIF(TRIM(@v_cst_id), ''),
    cst_key             = NULLIF(TRIM(@v_cst_key), ''),
    cst_first_name      = NULLIF(TRIM(@v_cst_first_name), ''),
    cst_last_name       = NULLIF(TRIM(@v_cst_last_name), ''),
    cst_marital_status  = NULLIF(TRIM(@v_cst_marital_status), ''),
    cst_gndr            = NULLIF(TRIM(@v_cst_gndr), ''),
    cst_create_date     = NULLIF(TRIM(@v_cst_create_date), ''),
    source_system       = 'CRM';

SET @cust_end = NOW();
SELECT CONCAT(
    '>> bronze.crm_cust_info 加载完成，耗时：',
    TIMESTAMPDIFF(SECOND, @cust_start, @cust_end),
    ' 秒'
) AS msg;

-- =========================================================
-- CRM: 产品信息表加载
-- =========================================================
SET @prd_start = NOW();
SELECT '>> Loading bronze.crm_prd_info' AS msg;

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

SET @prd_end = NOW();
SELECT CONCAT(
    '>> bronze.crm_prd_info 加载完成，耗时：',
    TIMESTAMPDIFF(SECOND, @prd_start, @prd_end),
    ' 秒'
) AS msg;

-- =========================================================
-- CRM: 销售明细表加载
-- =========================================================
SET @sales_start = NOW();
SELECT '>> Loading bronze.crm_sales_details' AS msg;

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

SET @sales_end = NOW();
SELECT CONCAT(
    '>> bronze.crm_sales_details 加载完成，耗时：',
    TIMESTAMPDIFF(SECOND, @sales_start, @sales_end),
    ' 秒'
) AS msg;

-- =========================================================
-- ERP: 客户扩展表加载
-- =========================================================
SET @erp_cust_start = NOW();
SELECT '>> Loading bronze.erp_cust_az12' AS msg;

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

SET @erp_cust_end = NOW();
SELECT CONCAT(
    '>> bronze.erp_cust_az12 加载完成，耗时：',
    TIMESTAMPDIFF(SECOND, @erp_cust_start, @erp_cust_end),
    ' 秒'
) AS msg;

-- =========================================================
-- ERP: 地理位置表加载
-- =========================================================
SET @erp_loc_start = NOW();
SELECT '>> Loading bronze.erp_loc_a101' AS msg;

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

SET @erp_loc_end = NOW();
SELECT CONCAT(
    '>> bronze.erp_loc_a101 加载完成，耗时：',
    TIMESTAMPDIFF(SECOND, @erp_loc_start, @erp_loc_end),
    ' 秒'
) AS msg;

-- =========================================================
-- ERP: 产品类别表加载
-- =========================================================
SET @erp_cat_start = NOW();
SELECT '>> Loading bronze.erp_px_cat_g1v2' AS msg;

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

SET @erp_cat_end = NOW();
SELECT CONCAT(
    '>> bronze.erp_px_cat_g1v2 加载完成，耗时：',
    TIMESTAMPDIFF(SECOND, @erp_cat_start, @erp_cat_end),
    ' 秒'
) AS msg;

-- 全部加载完成
SELECT '========== Bronze 层全部表加载完成 ==========' AS msg;
