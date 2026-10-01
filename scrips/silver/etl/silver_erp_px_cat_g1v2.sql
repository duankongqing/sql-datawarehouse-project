/*
================================================================================
脚本名称：silver_erp_px_cat_g1v2.sql
功能说明：
    将 Bronze 层 ERP 产品类别数据清洗标准化后，写入 Silver 层。

清洗逻辑：
    1. 全量覆盖：TRUNCATE 后 INSERT，保证数据一致性。
    2. 字段清洗：去除类别及维护标识字段前后空格。
    3. 字段命名：将源系统缩写字段映射为标准业务名称。
    4. 空值处理：缺失类别信息统一标记为 n/a。
    5. 保留数据来源：source_system 标记原始数据来源系统。
    6. dwh_create_date 由 Silver 表默认值自动生成。
================================================================================
*/

USE silver;

-- =========================================================
-- 1. 清空 Silver 目标表
-- =========================================================
SELECT '>> Truncating Table: silver.erp_px_cat_g1v2' AS msg;

TRUNCATE TABLE silver.erp_px_cat_g1v2;

-- =========================================================
-- 2. 清洗并加载数据
-- =========================================================
SELECT '>> Inserting Data Into: silver.erp_px_cat_g1v2' AS msg;

INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    category,
    sub_category,
    maintenance,
    source_system
)
SELECT
    TRIM(id) AS id,

    -- 一级品类
    CASE
        WHEN cat IS NULL OR TRIM(cat) = '' THEN 'n/a'
        ELSE TRIM(cat)
    END AS category,

    -- 二级品类
    CASE
        WHEN subcat IS NULL OR TRIM(subcat) = '' THEN 'n/a'
        ELSE TRIM(subcat)
    END AS sub_category,

    -- 维护标识
    CASE
        WHEN maintenance IS NULL OR TRIM(maintenance) = '' THEN 'n/a'
        ELSE TRIM(maintenance)
    END AS maintenance,

    source_system

FROM bronze.erp_px_cat_g1v2;

-- =========================================================
-- 3. 加载结果校验
-- =========================================================
SELECT '>> silver.erp_px_cat_g1v2 load completed' AS msg;

SELECT *
FROM silver.erp_px_cat_g1v2;
