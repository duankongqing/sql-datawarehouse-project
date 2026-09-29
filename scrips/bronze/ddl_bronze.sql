/*
================================================================================
脚本名称：ddl_bronze.sql
数据层级：Bronze

功能说明：
    创建 Bronze 层数据库及源数据表。

设计原则：
    1. Bronze 层用于保存来自源系统的原始数据。
    2. 尽可能保持源数据的原始格式和字段粒度。
    3. 不在 Bronze 层进行业务清洗、数据标准化或业务聚合。
    4. 日期、金额等字段按照源文件格式进行落地，
       后续由 Silver 层负责数据类型转换和数据清洗。
    5. 增加数据来源及入库时间等技术元数据，便于数据追踪。

数据来源：
    CRM（客户关系管理系统）
    ERP（企业资源计划系统）

注意：
    执行本脚本会删除并重新创建 Bronze 数据库。
    数据库及表中的原有数据将被清除。
================================================================================
*/



USE bronze;


-- ============================================================
-- 4. CRM 客户信息表
-- ============================================================

DROP TABLE IF EXISTS crm_cust_info;

CREATE TABLE crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_first_name VARCHAR(50),
    cst_last_name VARCHAR(50),
    cst_material_stauts VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date VARCHAR(20),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据入库时间',

    source_system VARCHAR(100)
        COMMENT '数据来源系统'
);


-- ============================================================
-- 5. CRM 产品信息表
-- ============================================================

DROP TABLE IF EXISTS crm_prd_info;

CREATE TABLE crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt VARCHAR(30),
    prd_end_dt VARCHAR(30),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据入库时间',

    source_system VARCHAR(100)
        COMMENT '数据来源系统'
);


-- ============================================================
-- 6. CRM 销售明细表
-- ============================================================

DROP TABLE IF EXISTS crm_sales_details;

CREATE TABLE crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt VARCHAR(20),
    sls_ship_dt VARCHAR(20),
    sls_due_dt VARCHAR(20),
    sls_sales INT,
    sls_quantity INT,

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据入库时间',

    source_system VARCHAR(100)
        COMMENT '数据来源系统'
);


-- ============================================================
-- 7. ERP 地区国家表
-- ============================================================

DROP TABLE IF EXISTS erp_loc_a101;

CREATE TABLE erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据入库时间',

    source_system VARCHAR(100)
        COMMENT '数据来源系统'
);


-- ============================================================
-- 8. ERP 客户基础信息表
-- ============================================================

DROP TABLE IF EXISTS erp_cust_az12;

CREATE TABLE erp_cust_az12 (
    cid VARCHAR(50),
    bdate VARCHAR(20),
    gen VARCHAR(50),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据入库时间',

    source_system VARCHAR(100)
        COMMENT '数据来源系统'
);


-- ============================================================
-- 9. ERP 产品分类表
-- ============================================================

DROP TABLE IF EXISTS erp_px_cat_g1v2;

CREATE TABLE erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50),

    create_date DATETIME DEFAULT CURRENT_TIMESTAMP
        COMMENT '数据入库时间',

    source_system VARCHAR(100)
        COMMENT '数据来源系统'
);
