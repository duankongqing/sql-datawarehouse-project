/*
===============================================================================
Gold 层数据质量检查
===============================================================================

脚本用途：
    本脚本用于检查 Gold 层数据的完整性、一致性和准确性。

    主要检查内容：
    - 检查维度表中代理键的唯一性。
    - 检查事实表与维度表之间的引用完整性。
    - 验证 Gold 层数据模型中的表关联是否正确。

使用说明：
    - 建议在 Gold 层视图创建完成后执行本脚本。
    - 如果检查语句返回结果，应进一步调查并解决对应的数据问题。

===============================================================================
*/


-- ====================================================================
-- 检查 'gold.dim_customers'
-- ====================================================================

-- 检查 gold.dim_customers 中 customer_key 的唯一性
-- 预期结果：无查询结果

SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- 检查 'gold.dim_products'
-- ====================================================================

-- 检查 gold.dim_products 中 product_key 的唯一性
-- 预期结果：无查询结果

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ====================================================================
-- 检查 'gold.fact_sales'
-- ====================================================================

-- 检查事实表与客户维度、产品维度之间的数据关联
-- 目的：
--     验证 fact_sales 中的 customer_key 和 product_key
--     是否能够正确关联到对应的维度表。
--
-- 预期结果：无查询结果

SELECT
    *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL
   OR c.customer_key IS NULL;
