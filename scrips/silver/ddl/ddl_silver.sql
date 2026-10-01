/*
================================================================================
脚本名称：ddl_silver.sql
功能说明：
    创建 Silver 层清洗与标准化数据表。
设计原则：
    1. 承接 Bronze 层原始字符串数据，完成业务类型转换、字段命名标准化。
    2. 关联主键字段与 Bronze 层保持同名，降低跨层映射出错概率。
    3. 源系统缩写字段统一扩展为可读业务名称，统一业务语义。
    4. 金额类统一使用 DECIMAL(18,2)，日期类统一使用 DATE，ID 类按业务属性区分类型。
    5. 保留审计字段：source_system（数据来源）、dwh_create_date（本层加载时间）。
    6. 全量覆盖加载模式，配合 TRUNCATE + INSERT 执行清洗。
================================================================================
*/

CREATE DATABASE IF NOT EXISTS silver;
USE silver;

-- =========================================================
-- 1. CRM 客户信息表
-- =========================================================
DROP TABLE IF EXISTS crm_cust_info;
CREATE TABLE crm_cust_info (
    cst_id              INT COMMENT '客户ID',
    cst_key             VARCHAR(50) COMMENT '客户业务编码',
    cst_first_name      VARCHAR(50) COMMENT '名',
    cst_last_name       VARCHAR(50) COMMENT '姓',
    cst_marital_status  VARCHAR(50) COMMENT '婚姻状态（标准化：Married/Single）',
    cst_gender          VARCHAR(50) COMMENT '性别（标准化：Male/Female）',
    cst_create_date     DATE COMMENT '客户创建日期',
    source_system       VARCHAR(50) COMMENT '数据来源系统',
    dwh_create_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '数仓Silver层加载时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CRM客户表-Silver层（清洗标准化）';

-- =========================================================
-- 2. CRM 产品信息表
-- =========================================================
DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info (
    prd_id          INT COMMENT '产品ID',
    prd_key         VARCHAR(50) COMMENT '产品业务编码',
    prd_nm          VARCHAR(100) COMMENT '产品名称',
    prd_cost        DECIMAL(18,2) COMMENT '产品成本',
    prd_line        VARCHAR(50) COMMENT '产品线',
    prd_start_dt    DATE COMMENT '产品生效日期',
    prd_end_dt      DATE COMMENT '产品失效日期',
    source_system   VARCHAR(50) COMMENT '数据来源系统',
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '数仓Silver层加载时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CRM产品表-Silver层（清洗标准化）';

-- =========================================================
-- 3. CRM 销售明细表
-- =========================================================
DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details (
    sls_ord_num     VARCHAR(100) COMMENT '订单号',
    sls_prd_key     VARCHAR(50) COMMENT '产品业务编码',
    sls_cust_id     INT COMMENT '客户ID',
    sls_order_dt    DATE COMMENT '订单日期',
    sls_ship_dt     DATE COMMENT '发货日期',
    sls_due_dt      DATE COMMENT '账期到期日',
    sls_sales       DECIMAL(18,2) COMMENT '销售总金额',
    sls_quantity    INT COMMENT '销售数量',
    sls_price       DECIMAL(18,2) COMMENT '销售单价',
    source_system   VARCHAR(50) COMMENT '数据来源系统',
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '数仓Silver层加载时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CRM销售明细表-Silver层（清洗标准化）';

-- =========================================================
-- 4. ERP 客户扩展表 (AZ12)
-- =========================================================
DROP TABLE IF EXISTS erp_cust_az12;
CREATE TABLE erp_cust_az12 (
    cid             VARCHAR(50) COMMENT '客户ID（关联主键，与Bronze一致）',
    birth_date      DATE COMMENT '客户出生日期',
    gender          VARCHAR(50) COMMENT '性别（标准化）',
    source_system   VARCHAR(50) COMMENT '数据来源系统',
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '数仓Silver层加载时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ERP客户扩展表-Silver层（清洗标准化）';

-- =========================================================
-- 5. ERP 地理位置表 (A101)
-- =========================================================
DROP TABLE IF EXISTS erp_loc_a101;
CREATE TABLE erp_loc_a101 (
    cid             VARCHAR(50) COMMENT '客户ID（关联主键，与Bronze一致）',
    country         VARCHAR(50) COMMENT '国家',
    source_system   VARCHAR(50) COMMENT '数据来源系统',
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '数仓Silver层加载时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ERP地理位置表-Silver层（清洗标准化）';

-- =========================================================
-- 6. ERP 产品类别表 (G1V2)
-- =========================================================
DROP TABLE IF EXISTS erp_px_cat_g1v2;
CREATE TABLE erp_px_cat_g1v2 (
    id              VARCHAR(50) COMMENT '品类ID（关联主键，与Bronze一致）',
    category        VARCHAR(50) COMMENT '一级品类',
    sub_category    VARCHAR(50) COMMENT '二级品类',
    maintenance     VARCHAR(50) COMMENT '维护标识',
    source_system   VARCHAR(50) COMMENT '数据来源系统',
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '数仓Silver层加载时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ERP产品类别表-Silver层（清洗标准化）';
