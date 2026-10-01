/*
================================================================================
脚本名称：ddl_bronze.sql
功能说明：
    创建 Bronze 层原始数据表。
设计原则：
    1. Bronze 层作为原始数据快照，完整保留源系统数据，支持溯源。
    2. 所有业务字段统一使用 VARCHAR，不在本层做强制类型转换，避免脏数据丢失。
    3. 仅做空值语义统一（空字符串转NULL），不做业务清洗、去重、代码标准化。
    4. create_date 为行级加载时间，由数据库默认值自动填充。
    5. source_system 标记数据来源系统，区分 CRM / ERP。
    6. 原始业务字段与技术审计字段分离，职责清晰。
数据来源：
    CRM 业务系统
    ERP 业务系统
================================================================================
*/

CREATE DATABASE IF NOT EXISTS bronze;
USE bronze;

-- =========================================================
-- CRM: 客户信息表
-- =========================================================
DROP TABLE IF EXISTS crm_cust_info;
CREATE TABLE crm_cust_info (
    cst_id               VARCHAR(50),
    cst_key              VARCHAR(50),
    cst_first_name       VARCHAR(50),
    cst_last_name        VARCHAR(50),
    cst_marital_status   VARCHAR(50),
    cst_gndr             VARCHAR(50),
    cst_create_date      VARCHAR(50),
    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据入库时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CRM客户表-Bronze原始层';

-- =========================================================
-- CRM: 产品信息表
-- =========================================================
DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info (
    prd_id               VARCHAR(50),
    prd_key              VARCHAR(50),
    prd_nm               VARCHAR(100),
    prd_cost             VARCHAR(50),
    prd_line             VARCHAR(50),
    prd_start_dt         VARCHAR(50),
    prd_end_dt           VARCHAR(50),
    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据入库时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CRM产品表-Bronze原始层';

-- =========================================================
-- CRM: 销售明细表
-- =========================================================
DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details (
    sls_ord_num          VARCHAR(100),
    sls_prd_key          VARCHAR(50),
    sls_cust_id          VARCHAR(50),
    sls_order_dt         VARCHAR(50),
    sls_ship_dt          VARCHAR(50),
    sls_due_dt           VARCHAR(50),
    sls_sales            VARCHAR(50),
    sls_quantity         VARCHAR(50),
    sls_price            VARCHAR(50),
    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据入库时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CRM销售明细表-Bronze原始层';

-- =========================================================
-- ERP: 客户扩展表 (AZ12)
-- =========================================================
DROP TABLE IF EXISTS erp_cust_az12;
CREATE TABLE erp_cust_az12 (
    cid                  VARCHAR(50),
    bdate                VARCHAR(50),
    gen                  VARCHAR(50),
    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据入库时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ERP客户扩展表-Bronze原始层';

-- =========================================================
-- ERP: 地理位置表 (A101)
-- =========================================================
DROP TABLE IF EXISTS erp_loc_a101;
CREATE TABLE erp_loc_a101 (
    cid                  VARCHAR(50),
    cntry                VARCHAR(50),
    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据入库时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ERP地理位置表-Bronze原始层';

-- =========================================================
-- ERP: 产品类别表 (G1V2)
-- =========================================================
DROP TABLE IF EXISTS erp_px_cat_g1v2;
CREATE TABLE erp_px_cat_g1v2 (
    id                   VARCHAR(50),
    cat                  VARCHAR(50),
    subcat               VARCHAR(50),
    maintenance          VARCHAR(50),
    create_date          DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '数据入库时间',
    source_system        VARCHAR(50) COMMENT '数据来源系统'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ERP产品类别表-Bronze原始层';
