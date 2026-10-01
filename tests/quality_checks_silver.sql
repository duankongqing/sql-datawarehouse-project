/*
===============================================================================
质量检查
===============================================================================
脚本目的：
    该脚本用于对“银层（silver layer）”中的数据进行一致性、准确性和标准化方面的
    多种质量检查。包括以下检查：
    - 主键中的空值或重复值。
    - 字符串字段中不需要的空格。
    - 数据标准化与一致性。
    - 无效的日期范围和日期顺序。
    - 相关字段之间的数据一致性。

使用说明：
    - 在数据加载到银层后运行这些检查。
    - 调查并解决检查过程中发现的任何差异。
===============================================================================
*/

-- ====================================================================
-- 检查 'silver.crm_cust_info'
-- ====================================================================
-- 检查主键中的 NULL 或重复值
-- 预期：无结果
SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 检查不需要的空格
-- 预期：无结果
SELECT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- 数据标准化与一致性
SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;

-- ====================================================================
-- 检查 'silver.crm_prd_info'
-- ====================================================================
-- 检查主键中的 NULL 或重复值
-- 预期：无结果
SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 检查不需要的空格
-- 预期：无结果
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- 检查成本中的 NULL 或负值
-- 预期：无结果
SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- 数据标准化与一致性
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;

-- 检查无效的日期顺序（开始日期 > 结束日期）
-- 预期：无结果
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- 检查 'silver.crm_sales_details'
-- ====================================================================
-- 检查无效日期
-- 预期：无无效日期
SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR CHAR_LENGTH(sls_due_dt) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

-- 检查无效的日期顺序（订单日期 > 发货日期/到期日期）
-- 预期：无结果
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- 检查数据一致性：销售额 = 数量 * 价格
-- 预期：无结果
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- 检查 'silver.erp_cust_az12'
-- ====================================================================
-- 识别超出范围的日期
-- 预期：出生日期在 1924-01-01 与今天之间
SELECT DISTINCT
    birth_date
FROM silver.erp_cust_az12
WHERE birth_date < '1924-01-01'
   OR birth_date > CURDATE();

-- 数据标准化与一致性
SELECT DISTINCT
    gender
FROM silver.erp_cust_az12;

-- ====================================================================
-- 检查 'silver.erp_loc_a101'
-- ====================================================================
-- 数据标准化与一致性
SELECT DISTINCT
    country
FROM silver.erp_loc_a101
ORDER BY country;

-- ====================================================================
-- 检查 'silver.erp_px_category_g1v2'
-- ====================================================================
-- 检查不需要的空格
-- 预期：无结果
SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE category != TRIM(category)
   OR sub_category != TRIM(sub_category)
   OR maintenance != TRIM(maintenance);

-- 数据标准化与一致性
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;
