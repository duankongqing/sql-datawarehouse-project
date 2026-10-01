/*
================================================================================
脚本名称：silver_erp_loc_a101.sql
功能说明：
    将 Bronze 层 ERP 客户地理位置数据清洗标准化后，写入 Silver 层。

清洗逻辑：
    1. 全量覆盖：TRUNCATE 后 INSERT，保证数据一致性。
    2. 客户ID清洗：去除 CID 中的连字符，统一ID格式。
    3. 国家代码标准化：将常见国家代码转换为完整国家名称。
    4. 空值处理：缺失国家信息统一标记为 n/a。
    5. 保留数据来源：source_system 标记原始数据来源系统。
    6. dwh_create_date 由 Silver 表默认值自动生成。
================================================================================
*/

USE silver;

-- =========================================================
-- 1. 清空 Silver 目标表
-- =========================================================
SELECT '>> Truncating Table: silver.erp_loc_a101' AS msg;

TRUNCATE TABLE silver.erp_loc_a101;

-- =========================================================
-- 2. 清洗并加载数据
-- =========================================================
SELECT '>> Inserting Data Into: silver.erp_loc_a101' AS msg;

INSERT INTO silver.erp_loc_a101 (
    cid,
    country,
    source_system
)
SELECT
    -- 去除客户ID中的连字符
    REPLACE(cid, '-', '') AS cid,

    -- 国家代码标准化
    CASE
        WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
        WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
        WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
        ELSE TRIM(cntry)
    END AS country,

    source_system

FROM bronze.erp_loc_a101;

-- =========================================================
-- 3. 加载结果校验
-- =========================================================
SELECT '>> silver.erp_loc_a101 load completed' AS msg;

SELECT *
FROM silver.erp_loc_a101;
