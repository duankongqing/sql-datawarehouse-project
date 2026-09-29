/*
====================================================================
脚本名称：Load Bronze Layer
脚本用途：
    从本地CSV源文件加载原始数据，写入bronze库。
    执行流程：
        1. TRUNCATE清空目标表
        2. LOAD DATA LOCAL INFILE导入CSV原始数据
        3. 批量赋值元数据字段 source_system，标记数据源
    元数据说明：
        create_date：建表时设置 DEFAULT CURRENT_TIMESTAMP，插入行自动填充ETL入库时间
        source_system：ETL附加溯源字段，标识数据来源系统(crm / erp)
注意事项：
    MySQL限制：LOAD DATA LOCAL INFILE 不能在存储过程内部执行，
    因此数据导入逻辑使用独立脚本运行。
====================================================================
*/
-- ===================== CRM客户信息表 crm_cust_info =====================
TRUNCATE TABLE bronze.crm_cust_info;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
UPDATE bronze.crm_cust_info SET source_system = 'crm' WHERE 1=1;

-- ===================== CRM产品表 crm_prd_info =====================
TRUNCATE TABLE bronze.crm_prd_info;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
UPDATE bronze.crm_prd_info SET source_system = 'crm' WHERE 1=1;

-- ===================== CRM销售明细表 crm_sales_details =====================
TRUNCATE TABLE bronze.crm_sales_details;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
UPDATE bronze.crm_sales_details SET source_system = 'crm' WHERE 1=1;

-- ===================== ERP客户信息表 erp_cust_az12 =====================
TRUNCATE TABLE bronze.erp_cust_az12;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
INTO TABLE bronze.erp_cust_az12
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
UPDATE bronze.erp_cust_az12 SET source_system = 'erp' WHERE 1=1;

-- ===================== ERP地区国家表 erp_loc_a101 =====================
TRUNCATE TABLE bronze.erp_loc_a101;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
INTO TABLE bronze.erp_loc_a101
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
UPDATE bronze.erp_loc_a101 SET source_system = 'erp' WHERE 1=1;

-- ===================== ERP产品分类表 erp_px_cat_g1v2 =====================
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
UPDATE bronze.erp_px_cat_g1v2 SET source_system = 'erp' WHERE 1=1;

