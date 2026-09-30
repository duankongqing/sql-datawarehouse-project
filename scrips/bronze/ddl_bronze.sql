/*
================================================================================
脚本名称：ddl_bronze.sql

功能说明：
    创建 Bronze 层原始数据表。

设计原则：
    1. Bronze 层尽可能保留源系统原始数据。
    2. 业务字段不在 Bronze 层进行数据类型转换。
    3. 不处理空值、异常值、重复数据。
    4. create_date 用于记录数据进入 Bronze 层的时间。
    5. source_system 用于记录数据来源系统。
    6. CSV 原始字段与技术元数据字段分离。

数据来源：
    CRM 系统
    ERP 系统
================================================================================
*/

USE bronze;

-- =========================================================
-- CRM: Customer
-- =========================================================

DROP TABLE IF EXISTS crm_cust_info;

CREATE TABLE crm_cust_info (
    cst_id               INT,
    cst_key              VARCHAR(50),
    cst_first_name       VARCHAR(50),
    cst_last_name        VARCHAR(50),
    cst_material_stauts  VARCHAR(50),
    cst_gndr             VARCHAR(50),
    cst_create_date      DATE,

    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据加载时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
);


-- =========================================================
-- CRM: Product
-- =========================================================

DROP TABLE IF EXISTS crm_prd_info;

CREATE TABLE crm_prd_info (
    prd_id               INT,
    prd_key              VARCHAR(50),
    prd_nm               VARCHAR(100),
    prd_cost             DECIMAL(18,2),
    prd_line             VARCHAR(50),
    prd_start_dt         DATE,
    prd_end_dt           DATE,

    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据加载时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
);


-- =========================================================
-- CRM: Sales Details
-- =========================================================

DROP TABLE IF EXISTS crm_sales_details;

CREATE TABLE crm_sales_details (
    sls_ord_num          VARCHAR(50),
    sls_prd_key          VARCHAR(50),
    sls_cust_id          INT,
    sls_order_dt         VARCHAR(50),
    sls_ship_dt          VARCHAR(50),
    sls_due_dt           VARCHAR(50),
    sls_sales            DECIMAL(18,2),
    sls_quantity         INT,
    sls_price             DECIMAL(18,2),

    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据加载时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
);


-- =========================================================
-- ERP: Customer
-- =========================================================

DROP TABLE IF EXISTS erp_cust_az12;

CREATE TABLE erp_cust_az12 (
    cid                  VARCHAR(50),
    bdate                DATE,
    gen                  VARCHAR(50),

    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据加载时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
);


-- =========================================================
-- ERP: Location
-- =========================================================

DROP TABLE IF EXISTS erp_loc_a101;

CREATE TABLE erp_loc_a101 (
    cid                  VARCHAR(50),
    cntry                VARCHAR(50),

    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据加载时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
);


-- =========================================================
-- ERP: Product Category
-- =========================================================

DROP TABLE IF EXISTS erp_px_cat_g1v2;

CREATE TABLE erp_px_cat_g1v2 (
    id                   VARCHAR(50),
    cat                  VARCHAR(50),
    subcat               VARCHAR(50),
    maintenance          VARCHAR(50),

    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据加载时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
);
