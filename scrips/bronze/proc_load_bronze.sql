/*
====================================================================
存储过程：Load Bronze Layer（源文件 -> Bronze层）
====================================================================
脚本用途：
    该存储过程从外部CSV文件加载数据，写入bronze库（schema）。
    执行以下操作：
    - 在加载数据前，先清空bronze层的目标表
    - 使用BULK INSERT（MySQL替换为LOAD DATA）把CSV文件数据导入bronze表

参数：
    无。
    本存储过程不需要传入参数，也不返回任何值。

调用示例：
    CALL bronze.load_bronze();

⚠️重要提醒：MySQL限制：LOAD DATA LOCAL INFILE 不能放在存储过程内部！
下面这份注释是对齐原SQL Server文档的说明，实际执行导入要单独运行LOAD DATA脚本。
====================================================================
*/

-- ===================== 【CRM客户表】crm_cust_info =====================
TRUNCATE TABLE bronze.crm_cust_info;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ===================== 【CRM产品表】crm_prd_info =====================
TRUNCATE TABLE bronze.crm_prd_info;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ===================== 【CRM销售明细表】crm_sales_details =====================
TRUNCATE TABLE bronze.crm_sales_details;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ===================== 【ERP客户信息表】erp_cust_az12 =====================
TRUNCATE TABLE bronze.erp_cust_az12;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
INTO TABLE bronze.erp_cust_az12
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ===================== 【ERP地区国家表】erp_loc_a101 =====================
TRUNCATE TABLE bronze.erp_loc_a101;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
INTO TABLE bronze.erp_loc_a101
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ===================== 【ERP产品分类表】erp_px_cat_g1v2 =====================
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
LOAD DATA LOCAL INFILE 'D:/sql_course/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
