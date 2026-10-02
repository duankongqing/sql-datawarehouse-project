/*
================================================================================
脚本名称：ddl
_gold.sql
脚本用途：创建 Gold 层维度表和事实表视图
================================================================================

功能说明：
    Gold 层用于构建面向
业务分析的数据模型。
    本脚本基于 Silver 层经过清洗和标准化的数据，
    创建客户维度、产品维度以及销售事实视图，
    为后续的数据分析、报表和业务查询提供统一的数据来源。

创建对象：
    1. gold.dim_customers    —— 客户维度
    2. gold.dim_products     —— 产品维度
    3. gold.fact_sales       —— 销售事实

设计说明：
    - Gold 层采用维度模型组织业务数据。
    - 维度视图使用 ROW_NUMBER() 生成代理键（Surrogate Key）。
    - 产品维度仅保留当前有效的产品记录。
    - 销售事实通过代理键关联客户维度和产品维度。
    - 本项目 Gold 层采用 View 方式构建，避免重复存储 Silver 层数据。

================================================================================
*/


-- =============================================================================
-- 创建客户维度
-- =============================================================================
-- 功能：
--     整合 CRM 客户信息以及 ERP 中的客户人口属性和地区信息，
--     形成统一的客户维度，为后续客户分析提供完整的客户属性。
--
-- 主要处理：
--     1. 使用 ROW_NUMBER() 生成客户代理键 customer_key。
--     2. 保留 CRM 中的客户基本信息。
--     3. 从 ERP 获取客户性别和出生日期等补充信息。
--     4. 从 ERP 获取客户所在国家。
--     5. 当 CRM 中的性别为 'n/a' 时，使用 ERP 中的性别进行补充。
-- =============================================================================

DROP VIEW IF EXISTS gold.dim_customers;

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_first_name AS first_name,
    ci.cst_last_name AS last_name,
    la.country AS country,
    ci.cst_marital_status AS marital_status,
    CASE
        WHEN ci.cst_gender != 'n/a' THEN ci.cst_gender
        ELSE COALESCE(ca.gender, 'n/a')
    END AS gender,
    ca.birth_date AS birthday,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;


-- =============================================================================
-- 创建产品维度
-- =============================================================================
-- 功能：
--     整合 CRM 产品基本信息和 ERP 产品分类信息，
--     构建统一的产品维度，为产品分析和销售分析提供基础。
--
-- 主要处理：
--     1. 使用 ROW_NUMBER() 生成产品代理键 product_key。
--     2. 保留产品基本信息、成本和产品线等属性。
--     3. 关联 ERP 产品分类，补充类别、子类别和维护信息。
--     4. 仅保留当前有效的产品记录，过滤历史版本。
-- =============================================================================

DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY pn.prd_start_dt, pn.prd_key
    ) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.category,
    pc.sub_category AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;


-- =============================================================================
-- 创建销售事实
-- =============================================================================
-- 功能：
--     构建销售业务事实视图，将销售明细与客户维度和产品维度进行关联，
--     形成面向业务分析的销售事实数据。
--
-- 主要处理：
--     1. 保留销售订单、日期、金额、数量和价格等业务指标。
--     2. 通过产品编号关联产品维度，获取 product_key。
--     3. 通过客户编号关联客户维度，获取 customer_key。
--     4. 使用维度表中的代理键连接事实数据和维度数据。
-- =============================================================================

DROP VIEW IF EXISTS gold.fact_sales;

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;

