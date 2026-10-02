/*
================================================================================
Gold 层数据质量检查
================================================================================

脚本用途：
    本脚本用于检查 Gold 层数据的完整性、一致性以及数据模型中的关联关系。

    主要检查内容：
    - 检查维度表代理键的唯一性。
    - 检查事实表与维度表之间的引用完整性。
    - 检查事实表中的维度代理键是否能够正确关联到对应维度。

使用说明：
    - 建议在 Gold 层视图创建完成后执行本脚本。
    - 正常情况下，各项检查均应无查询结果。
    - 如果返回数据，应进一步检查对应的数据记录。

================================================================================
*/


-- =============================================================================
-- 检查 gold.dim_customers
-- =============================================================================


-- 检查客户代理键是否唯一
-- 预期结果：无查询结果

SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- =============================================================================
-- 检查 gold.dim_products
-- =============================================================================


-- 检查产品代理键是否唯一
-- 预期结果：无查询结果

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- =============================================================================
-- 检查 gold.fact_sales
-- =============================================================================


-- 检查销售事实中的客户代理键是否能够关联到客户维度
-- 目的：
--     验证 fact_sales.customer_key 是否都能在 dim_customers 中找到对应记录。
--
-- 预期结果：无查询结果

SELECT DISTINCT
    fs.customer_key
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
    ON fs.customer_key = dc.customer_key
WHERE fs.customer_key IS NOT NULL
  AND dc.customer_key IS NULL;


-- 检查销售事实中的产品代理键是否能够关联到产品维度
-- 目的：
--     验证 fact_sales.product_key 是否都能在 dim_products 中找到对应记录。
--
-- 预期结果：无查询结果

SELECT DISTINCT
    fs.product_key
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
    ON fs.product_key = dp.product_key
WHERE fs.product_key IS NOT NULL
  AND dp.product_key IS NULL;


-- 检查销售事实中的客户代理键是否存在 NULL
-- 目的：
--     检查销售事实是否存在无法匹配客户维度的记录。
--
-- 预期结果：无查询结果

SELECT
    *
FROM gold.fact_sales
WHERE customer_key IS NULL;


-- 检查销售事实中的产品代理键是否存在 NULL
-- 目的：
--     检查销售事实是否存在无法匹配产品维度的记录。
--
-- 预期结果：无查询结果

SELECT
    *
FROM gold.fact_sales
WHERE product_key IS NULL;
