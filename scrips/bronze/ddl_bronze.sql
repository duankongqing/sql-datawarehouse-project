/*
================================================================================
脚本名称：ddl_bronze.sql

功能说明：
    创建 Bronze 层原始数据表。

数据说明：
    Bronze 层用于存储来自不同业务系统的原始数据，
    保留源系统数据结构和数据格式，不进行数据清洗和业务转换。

设计原则：
    1. 保持源数据原始状态。
    2. 不进行数据类型转换。
    3. 不处理空值、异常值和重复数据。
    4. 增加数据加载时间和来源系统字段，支持数据追踪。

数据来源：
    CRM 系统
    ERP 系统

================================================================================
*/


USE bronze;


-- ============================================================
-- CRM 客户信息表
-- ============================================================

DROP TABLE IF EXISTS crm_cust_info;

CREATE TABLE crm_cust_info (
    cst_id VARCHAR(50),
    cst_key VARCHAR(50),
    cst_first_name VARCHAR(50),
    cst_last_name VARCHAR(50),
    cst_material_stauts VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date VARCHAR(50),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据加载时间',

    source_system VARCHAR(50)
        COMMENT '数据来源系统'
);


-- ============================================================
-- CRM 产品信息表
-- ============================================================

DROP TABLE IF EXISTS crm_prd_info;

CREATE TABLE crm_prd_info (
    prd_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost VARCHAR(50),
    prd_line VARCHAR(50),
    prd_start_dt VARCHAR(50),
    prd_end_dt VARCHAR(50),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据加载时间',

    source_system VARCHAR(50)
        COMMENT '数据来源系统'
);


-- ============================================================
-- CRM 销售明细表
-- ============================================================

DROP TABLE IF EXISTS crm_sales_details;

CREATE TABLE crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id VARCHAR(50),
    sls_order_dt VARCHAR(50),
    sls_ship_dt VARCHAR(50),
    sls_due_dt VARCHAR(50),
    sls_sales VARCHAR(50),
    sls_quantity VARCHAR(50),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据加载时间',

    source_system VARCHAR(50)
        COMMENT '数据来源系统'
);


-- ============================================================
-- ERP 地区国家信息表
-- ============================================================

DROP TABLE IF EXISTS erp_loc_a101;

CREATE TABLE erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据加载时间',

    source_system VARCHAR(50)
        COMMENT '数据来源系统'
);


-- ============================================================
-- ERP 客户基础信息表
-- ============================================================

DROP TABLE IF EXISTS erp_cust_az12;

CREATE TABLE erp_cust_az12 (
    cid VARCHAR(50),
    bdate VARCHAR(50),
    gen VARCHAR(50),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据加载时间',

    source_system VARCHAR(50)
        COMMENT '数据来源系统'
);


-- ============================================================
-- ERP 产品分类信息表
-- ============================================================

DROP TABLE IF EXISTS erp_px_cat_g1v2;

CREATE TABLE erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据加载时间',

    source_system VARCHAR(50)
        COMMENT '数据来源系统'
);
