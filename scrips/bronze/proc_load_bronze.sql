/*
================================================================================
脚本名称：proc_load_bronze.sql

功能说明：
    将 CRM 和 ERP 系统提供的源数据文件加载至 Bronze 层。

处理流程：
    
    Source System
          |
          |  CSV文件
          ↓
    Bronze Layer

加载规则：
    1. 采用全量加载方式。
    2. 每次加载前清空目标表，保证数据完整刷新。
    3. 保留源系统数据原始格式，不进行数据清洗和转换。
    4. 加载完成后补充技术元数据：
       - create_date：记录数据进入 Bronze 层的时间。
       - source_system：记录数据来源系统。

数据来源：
    - CRM（Customer Relationship Management）
    - ERP（Enterprise Resource Planning）

加载方式：
    MySQL LOAD DATA LOCAL INFILE

================================================================================
*/


USE bronze;



-- ============================================================
-- CRM 客户信息表
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
-- CRM 产品信息表
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
-- CRM 销售明细表
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
-- ERP 客户基础信息表
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
-- ERP 地区国家信息表
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
-- ERP 产品分类信息表
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
