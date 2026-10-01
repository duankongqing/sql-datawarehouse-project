/*
================================================================================
脚本名称：silver_crm_cust_info.sql
功能说明：
    将 Bronze 层 CRM 客户原始数据清洗标准化后，写入 Silver 层。
清洗逻辑：
    1. 全量覆盖：TRUNCATE 后 INSERT，保证数据一致性
    2. 主键去重：按 cst_id 分组，取最新创建日期的记录（ROW_NUMBER）
    3. 字段清洗：去前后空格、婚姻状态/性别代码标准化
    4. 类型转换：字符串转 INT / DATE 标准业务类型
    5. 耗时统计：记录表级执行时长，用于性能观测
================================================================================
*/

USE silver;

-- 记录执行开始时间
SET @start_time = NOW();
SELECT '>> Truncating Table: silver.crm_cust_info' AS msg;

TRUNCATE TABLE silver.crm_cust_info;

SELECT '>> Inserting Data Into: silver.crm_cust_info' AS msg;

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_first_name,
    cst_last_name,
    cst_marital_status,
    cst_gender,
    cst_create_date,
    source_system
)
SELECT
    CAST(cst_id AS SIGNED) AS cst_id,
    cst_key,
    TRIM(cst_first_name) AS cst_first_name,
    TRIM(cst_last_name) AS cst_last_name,
    -- 婚姻状态代码标准化：统一转为可读全称，异常值标记为 n/a
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END AS cst_marital_status,
    -- 性别代码标准化：统一转为可读全称，异常值标记为 n/a
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gender,
    -- 字符串业务日期转为标准 DATE 类型
    STR_TO_DATE(cst_create_date, '%Y-%m-%d') AS cst_create_date,
    source_system
FROM (
    -- 子查询：按客户主键去重，保留最新创建的一条记录
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id
            ORDER BY STR_TO_DATE(cst_create_date, '%Y-%m-%d') DESC
        ) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;

-- 计算并输出执行耗时
SET @end_time = NOW();
SELECT CONCAT(
    '>> Load Duration: ',
    TIMESTAMPDIFF(SECOND, @start_time, @end_time),
    ' seconds'
) AS msg;

SELECT '>> silver.crm_cust_info load completed' AS msg;


