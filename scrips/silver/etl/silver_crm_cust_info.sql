/*
================================================================================
脚本名称：silver_crm_cust_info.sql
功能说明：
    将 Bronze 层 CRM 客户原始数据清洗标准化后，写入 Silver 层。

清洗逻辑：
    1. 全量覆盖：TRUNCATE 后 INSERT，保证数据一致性。
    2. 主键去重：按 cst_id 分组，保留创建日期最新的一条客户记录。
    3. 字段清洗：去除姓名及业务编码前后空格。
    4. 状态标准化：将婚姻状态代码转换为可读业务名称。
    5. 性别标准化：将性别代码转换为可读业务名称。
    6. 类型转换：将 Bronze 字符串数据转换为 INT / DATE。
    7. 异常值处理：无法识别的状态或性别统一标记为 n/a。
    8. 保留数据来源：source_system 标记原始数据来源系统。
    9. dwh_create_date 由 Silver 表默认值自动生成。
================================================================================
*/

USE silver;

-- =========================================================
-- 1. 清空 Silver 目标表
-- =========================================================
SELECT '>> Truncating Table: silver.crm_cust_info' AS msg;

TRUNCATE TABLE silver.crm_cust_info;

-- =========================================================
-- 2. 清洗并加载数据
-- =========================================================
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
    -- 客户ID：字符串转换为整数
    CAST(cst_id AS SIGNED) AS cst_id,

    -- 客户业务编码
    TRIM(cst_key) AS cst_key,

    -- 姓名字段去除前后空格
    TRIM(cst_first_name) AS cst_first_name,
    TRIM(cst_last_name) AS cst_last_name,

    -- 婚姻状态标准化
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END AS cst_marital_status,

    -- 性别标准化
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gender,

    -- 字符串日期转换为 DATE
    STR_TO_DATE(cst_create_date, '%Y-%m-%d') AS cst_create_date,

    source_system

FROM (
    /*
    --------------------------------------------------------------------------
    客户主键去重：
        同一个 cst_id 可能存在多条记录。
        使用 ROW_NUMBER 按创建日期倒序排列，
        保留每个客户最新的一条记录。
    --------------------------------------------------------------------------
    */
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id
            ORDER BY
                STR_TO_DATE(cst_create_date, '%Y-%m-%d') DESC
        ) AS row_num
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t

WHERE row_num = 1;

-- =========================================================
-- 3. 加载结果校验
-- =========================================================
SELECT '>> silver.crm_cust_info load completed' AS msg;


