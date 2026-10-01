/*
================================================================================
脚本名称：silver_erp_cust_az12.sql
功能说明：
    将 Bronze 层 ERP 客户扩展数据清洗标准化后，写入 Silver 层。

清洗逻辑：
    1. 全量覆盖：TRUNCATE 后 INSERT，保证数据一致性。
    2. 客户ID清洗：去除 CID 中的 NAS 前缀，统一客户ID格式。
    3. 日期清洗：未来出生日期视为异常数据，转换为 NULL。
    4. 性别标准化：统一转换为 Male / Female，异常值标记为 n/a。
    5. 字段类型转换：将 Bronze 字符串日期转换为 DATE。
    6. 保留数据来源：source_system 标记原始数据来源系统。
    7. dwh_create_date 由 Silver 表默认值自动生成。
================================================================================
*/

USE silver;

-- =========================================================
-- 1. 清空 Silver 目标表
-- =========================================================
SELECT '>> Truncating Table: silver.erp_cust_az12' AS msg;

TRUNCATE TABLE silver.erp_cust_az12;

-- =========================================================
-- 2. 清洗并加载数据
-- =========================================================
SELECT '>> Inserting Data Into: silver.erp_cust_az12' AS msg;

INSERT INTO silver.erp_cust_az12 (
    cid,
    birth_date,
    gender,
    source_system
)
SELECT
    -- 去除客户ID中的 NAS 前缀
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4)
        ELSE cid
    END AS cid,

    -- 出生日期不能晚于当前日期，异常值转换为 NULL
    CASE
        WHEN STR_TO_DATE(bdate, '%Y-%m-%d') > CURRENT_DATE THEN NULL
        ELSE STR_TO_DATE(bdate, '%Y-%m-%d')
    END AS birth_date,

    -- 性别代码标准化
    CASE
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gender,

    source_system

FROM bronze.erp_cust_az12;

-- =========================================================
-- 3. 加载结果校验
-- =========================================================
SELECT '>> silver.erp_cust_az12 load completed' AS msg;

