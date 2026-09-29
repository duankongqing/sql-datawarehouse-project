/*
================================================================================
脚本名称：proc_load_bronze.sql
数据层级：Bronze

功能说明：
    将 CRM 和 ERP 源系统的 CSV 文件加载至 Bronze 层。

设计原则：
    1. Bronze 层负责源数据落地。
    2. 保持源数据的原始字段和数据粒度。
    3. 不进行业务清洗和数据转换。
    4. 每次加载前清空目标表，确保本次加载结果完整一致。
    5. 记录数据来源系统和数据入库时间。

数据来源：
    CRM
    ERP

加载方式：
    MySQL LOAD DATA LOCAL INFILE

注意：
    1. 执行前请确认 MySQL 已启用 LOCAL INFILE。
    2. 请根据实际环境修改 CSV 文件路径。
    3. 本脚本采用全量加载方式。
================================================================================
*/


USE bronze;


-- ============================================================
-- 1. 加载 CRM 客户信息
-- ============================================================

TRUNCATE TABLE crm_cust_info;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE crm_cust_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

UPDATE crm_cust_info
SET source_system = 'CRM';


-- ============================================================
-- 2. 加载 CRM 产品信息
-- ============================================================

TRUNCATE TABLE crm_prd_info;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

UPDATE crm_prd_info
SET source_system = 'CRM';


-- ============================================================
-- 3. 加载 CRM 销售明细
-- ============================================================

TRUNCATE TABLE crm_sales_details;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

UPDATE crm_sales_details
SET source_system = 'CRM';


-- ============================================================
-- 4. 加载 ERP 客户基础信息
-- ============================================================

TRUNCATE TABLE erp_cust_az12;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
INTO TABLE erp_cust_az12
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

UPDATE erp_cust_az12
SET source_system = 'ERP';


-- ============================================================
-- 5. 加载 ERP 地区国家信息
-- ============================================================

TRUNCATE TABLE erp_loc_a101;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
INTO TABLE erp_loc_a101
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

UPDATE erp_loc_a101
SET source_system = 'ERP';


-- ============================================================
-- 6. 加载 ERP 产品分类信息
-- ============================================================

TRUNCATE TABLE erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE
'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE erp_px_cat_g1v2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

UPDATE erp_px_cat_g1v2
SET source_system = 'ERP';
