/*
================================================================================
脚本名称：创建 Bronze 层数据表
================================================================================
脚本说明：
1. 在 bronze 数据库中创建原始数据表
2. 如果表已经存在，则先删除原表，再重新创建
3. 本脚本用于重新定义 Bronze 层数据表的结构
4. Bronze 层用于保存从源系统导入的原始数据，附加溯源元数据列
注意：
- 本脚本使用 MySQL 语法
- 执行后原有表结构和数据都会被删除
- 新增元数据：create_date(ETL入库时间)、source_system(数据源系统)，不属于上游业务原始字段
================================================================================
*/
-- 删除旧表（如果存在），重建客户信息表
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
    cst_id INT,
    cst_key VARCHAR(50) CHARACTER SET utf8mb4,
    cst_first_name VARCHAR(50) CHARACTER SET utf8mb4,
    cst_last_name VARCHAR(50) CHARACTER SET utf8mb4,
    cst_material_stauts VARCHAR(50) CHARACTER SET utf8mb4,
    cst_gndr VARCHAR(50) CHARACTER SET utf8mb4,
    cst_create_date DATE,
    -- 元数据列 Metadata Columns
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'ETL数据入库时间',
    source_system VARCHAR(100) COMMENT '数据源系统'
);

-- 删除旧表（如果存在），重建产品信息表
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    prd_nm VARCHAR(50) CHARACTER SET utf8mb4,
    prd_cost INT,
    prd_line VARCHAR(50) CHARACTER SET utf8mb4,
    prd_start_dt DATETIME,
    prd_end_dt DATETIME,
    -- 元数据列 Metadata Columns
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'ETL数据入库时间',
    source_system VARCHAR(100) COMMENT '数据源系统'
);

-- 删除旧表（如果存在），重建销售明细表
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num VARCHAR(50) CHARACTER SET utf8mb4,
    sls_prd_key VARCHAR(50) CHARACTER SET utf8mb4,
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    -- 元数据列 Metadata Columns
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'ETL数据入库时间',
    source_system VARCHAR(100) COMMENT '数据源系统'
);

-- 删除旧表（如果存在），重建ERP地区位置表
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    cid VARCHAR(50) CHARACTER SET utf8mb4,
    cntry VARCHAR(50) CHARACTER SET utf8mb4,
    -- 元数据列 Metadata Columns
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'ETL数据入库时间',
    source_system VARCHAR(100) COMMENT '数据源系统'
);

-- 删除旧表（如果存在），重建ERP客户基础信息表
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    cid VARCHAR(50) CHARACTER SET utf8mb4,
    bdate DATE,
    gen VARCHAR(50) CHARACTER SET utf8mb4,
    -- 元数据列 Metadata Columns
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'ETL数据入库时间',
    source_system VARCHAR(100) COMMENT '数据源系统'
);

-- 删除旧表（如果存在），重建ERP产品分类表
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id VARCHAR(50) CHARACTER SET utf8mb4,
    cat VARCHAR(50) CHARACTER SET utf8mb4,
    subcat VARCHAR(50) CHARACTER SET utf8mb4,
    maintenance VARCHAR(50) CHARACTER SET utf8mb4,
    -- 元数据列 Metadata Columns
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'ETL数据入库时间',
    source_system VARCHAR(100) COMMENT '数据源系统'
);
