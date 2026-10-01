/*
================================================================================
脚本名称：silver_crm_sales_details.sql
功能说明：
    将 Bronze 层 CRM 销售明细原始数据清洗标准化后，写入 Silver 层。

清洗逻辑：
    1. 全量覆盖：TRUNCATE 后 INSERT，保证数据一致性。
    2. 字段清洗：去除订单号及产品编码前后空格。
    3. 类型转换：将客户ID、销售数量转换为 INT。
    4. 金额转换：将销售金额及销售价格转换为 DECIMAL(18,2)。
    5. 日期转换：将 YYYYMMDD 格式字符串转换为 DATE。
    6. 空值处理：空字符串在 Bronze 层已统一转换为 NULL。
    7. 保留数据来源：source_system 标记原始数据来源系统。
    8. dwh_create_date 由 Silver 表默认值自动生成。
================================================================================
*/

USE silver;

-- =========================================================
-- 1. 清空 Silver 目标表
-- =========================================================
SELECT '>> Truncating Table: silver.crm_sales_details' AS msg;

TRUNCATE TABLE silver.crm_sales_details;

-- =========================================================
-- 2. 清洗并加载数据
-- =========================================================
SELECT '>> Inserting Data Into: silver.crm_sales_details' AS msg;

INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price,
    source_system
)
SELECT
    -- 订单号
    TRIM(sls_ord_num) AS sls_ord_num,

    -- 产品业务编码
    TRIM(sls_prd_key) AS sls_prd_key,

    -- 客户ID：字符串转换为整数
    CAST(sls_cust_id AS SIGNED) AS sls_cust_id,

    -- 订单日期：YYYYMMDD → DATE
    CASE
        WHEN sls_order_dt IS NULL
             OR TRIM(sls_order_dt) = ''
             OR TRIM(sls_order_dt) = '0'
        THEN NULL
        ELSE STR_TO_DATE(sls_order_dt, '%Y%m%d')
    END AS sls_order_dt,

    -- 发货日期：YYYYMMDD → DATE
    CASE
        WHEN sls_ship_dt IS NULL
             OR TRIM(sls_ship_dt) = ''
             OR TRIM(sls_ship_dt) = '0'
        THEN NULL
        ELSE STR_TO_DATE(sls_ship_dt, '%Y%m%d')
    END AS sls_ship_dt,

    -- 到期日期：YYYYMMDD → DATE
    CASE
        WHEN sls_due_dt IS NULL
             OR TRIM(sls_due_dt) = ''
             OR TRIM(sls_due_dt) = '0'
        THEN NULL
        ELSE STR_TO_DATE(sls_due_dt, '%Y%m%d')
    END AS sls_due_dt,

    -- 销售金额：转换为 DECIMAL(18,2)
    CAST(sls_sales AS DECIMAL(18,2)) AS sls_sales,

    -- 销售数量：转换为整数
    CAST(sls_quantity AS SIGNED) AS sls_quantity,

    -- 销售单价：转换为 DECIMAL(18,2)
    CAST(sls_price AS DECIMAL(18,2)) AS sls_price,

    source_system

FROM bronze.crm_sales_details;

-- =========================================================
-- 3. 加载结果校验
-- =========================================================
SELECT '>> silver.crm_sales_details load completed' AS msg;

SELECT *
FROM silver.crm_sales_details;
```
