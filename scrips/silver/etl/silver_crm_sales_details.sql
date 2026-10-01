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
    6. 销售金额校验：金额为空、非正数或不等于数量 × 单价时，重新计算销售金额。 
    7. 销售价格校验：价格为空或非正数时，根据销售金额 ÷ 数量重新计算销售价格。 
    8. 空值处理：Bronze 层空值已统一转换为 NULL。 
    9. 保留数据来源：source_system 标记原始数据来源系统。 
   10. dwh_create_date 由 Silver 表默认值自动生成。 
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
        WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 
        THEN NULL 
        ELSE STR_TO_DATE(sls_order_dt, '%Y%m%d') 
    END AS sls_order_dt, 
 
    -- 发货日期：YYYYMMDD → DATE 
    CASE 
        WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 
        THEN NULL 
        ELSE STR_TO_DATE(sls_ship_dt, '%Y%m%d') 
    END AS sls_ship_dt, 
 
    -- 到期日期：YYYYMMDD → DATE 
    CASE 
        WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 
        THEN NULL 
        ELSE STR_TO_DATE(sls_due_dt, '%Y%m%d') 
    END AS sls_due_dt, 
 
    -- 销售金额：为空、非正数或与数量 × 单价不一致时重新计算 
    CASE 
        WHEN sls_sales IS NULL 
             OR sls_sales <= 0 
             OR sls_sales != sls_quantity * ABS(sls_price) 
        THEN sls_quantity * ABS(sls_price) 
        ELSE sls_sales 
    END AS sls_sales, 
 
    -- 销售数量：转换为整数 
    CAST(sls_quantity AS SIGNED) AS sls_quantity, 
 
    -- 销售单价：为空或非正数时，根据销售金额 ÷ 数量重新计算 
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0 
        THEN sls_sales / NULLIF(sls_quantity, 0) 
        ELSE sls_price 
    END AS sls_price, 
 
    source_system 
 
FROM bronze.crm_sales_details; 
 
-- ========================================================= 
-- 3. 加载结果校验 
-- ========================================================= 
SELECT '>> silver.crm_sales_details load completed' AS msg; 
