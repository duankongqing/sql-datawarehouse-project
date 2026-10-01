/* ================================================================================
脚本名称：silver_crm_prd_info.sql
功能说明：
    将 Bronze 层 CRM 产品原始数据清洗标准化后，写入 Silver 层。
清洗逻辑：
    1. 全量覆盖：TRUNCATE 后 INSERT，保证数据一致性
    2. 字段清洗：拆分prd_key得到cat_id，产品线编码标准化
    3. 时间窗口计算：使用LEAD窗口函数计算产品有效期结束日期
    4. 空值处理：空字符串转为0，适配成本字段
    5. 耗时统计：记录表级执行时长，用于性能观测
================================================================================ */
USE silver;

-- 记录执行开始时间
SET @start_time = NOW();
SELECT '>> Truncating Table: silver.crm_prd_info' AS msg;

TRUNCATE TABLE silver.crm_prd_info;

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
    create_date,
    source_system
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7) AS prd_key,
    TRIM(prd_nm) AS prd_nm,
    IFNULL(NULLIF(prd_cost, ''), 0) AS prd_cost,
    CASE UPPER(TRIM(prd_line))
         WHEN 'M' THEN 'Mountain'
         WHEN 'R' THEN 'Road'
         WHEN 'S' THEN 'other Sales'
         WHEN 'T' THEN 'Touring'
         ELSE 'n/a'
    END AS prd_line,
    prd_start_dt,
    DATE_SUB(
        LEAD(prd_start_dt) OVER (
            PARTITION BY prd_key
            ORDER BY prd_start_dt
        ),
        INTERVAL 1 DAY
    ) AS prd_end_dt,
    create_date,
    source_system
FROM bronze.crm_prd_info;

-- 计算并输出执行耗时
SET @end_time = NOW();
SELECT CONCAT(
    '>> Load Duration: ',
    TIMESTAMPDIFF(SECOND, @start_time, @end_time),
    ' seconds'
) AS msg;

SELECT '>> silver.crm_prd_info load completed' AS msg;

-- 校验查看
SELECT * FROM silver.crm_prd_info;
