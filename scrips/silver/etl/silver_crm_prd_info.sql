/*
================================================================================
脚本名称：silver_crm_prd_info.sql
功能说明：
    将 Bronze 层 CRM 产品原始数据清洗标准化后，写入 Silver 层。

清洗逻辑：
    1. 全量覆盖：TRUNCATE 后 INSERT，保证数据一致性。
    2. 品类解析：从产品业务编码中提取并标准化 cat_id。
    3. 产品编码：提取产品业务编码中的产品部分。
    4. 产品名称：去除前后空格。
    5. 成本清洗：空成本转换为 0，并统一为 DECIMAL 类型。
    6. 产品线标准化：将产品线代码转换为可读业务名称。
    7. 时间窗口计算：使用 LEAD 计算产品失效日期。
    8. 日期转换：将 Bronze 字符串日期转换为 DATE。
    9. 保留数据来源：source_system 标记原始数据来源系统。
    10. dwh_create_date 由 Silver 表默认值自动生成。
================================================================================
*/

USE silver;

-- =========================================================
-- 1. 清空 Silver 目标表
-- =========================================================
SELECT '>> Truncating Table: silver.crm_prd_info' AS msg;

TRUNCATE TABLE silver.crm_prd_info;

-- =========================================================
-- 2. 清洗并加载数据
-- =========================================================
SELECT '>> Inserting Data Into: silver.crm_prd_info' AS msg;

INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt,
    source_system
)
SELECT
    CAST(prd_id AS SIGNED) AS prd_id,

    -- 从产品业务编码中提取品类ID
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,

    -- 提取产品业务编码中的产品部分
    SUBSTRING(prd_key, 7) AS prd_key,

    -- 产品名称去除前后空格
    TRIM(prd_nm) AS prd_nm,

    -- 成本字段空值转换为 0
    CAST(
        IFNULL(NULLIF(TRIM(prd_cost), ''), 0)
        AS DECIMAL(18,2)
    ) AS prd_cost,

    -- 产品线代码标准化
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,

    -- 字符串日期转换为 DATE
    STR_TO_DATE(prd_start_dt, '%Y-%m-%d') AS prd_start_dt,

    -- 根据下一条记录的生效日期计算当前记录的失效日期
    DATE_SUB(
        LEAD(
            STR_TO_DATE(prd_start_dt, '%Y-%m-%d')
        ) OVER (
            PARTITION BY prd_key
            ORDER BY STR_TO_DATE(prd_start_dt, '%Y-%m-%d')
        ),
        INTERVAL 1 DAY
    ) AS prd_end_dt,

    source_system

FROM bronze.crm_prd_info;

-- =========================================================
-- 3. 加载结果校验
-- =========================================================
SELECT '>> silver.crm_prd_info load completed' AS msg;
