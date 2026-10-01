/*
================================================================================
脚本名称：run_all_silver.sql
功能说明：
    Silver 层全量清洗总控入口，按业务依赖顺序依次执行所有表的清洗脚本。
执行顺序（先维度后事实）：
    1. CRM 客户维度
    2. CRM 产品维度
    3. CRM 销售明细事实
    4. ERP 客户扩展维度
    5. ERP 地理位置维度
    6. ERP 产品类别维度
使用说明：
    - 全量刷新：依次执行下方对应脚本
    - 单表重跑：直接执行对应单表脚本，无需运行总控
================================================================================
*/

USE silver;

SELECT '========== 开始执行 Silver 层全量清洗 ==========' AS msg;

-- 1. CRM 客户信息表
-- 执行：silver_crm_cust_info.sql

-- 2. CRM 产品信息表
-- 执行：silver_crm_prd_info.sql

-- 3. CRM 销售明细表
-- 执行：silver_crm_sales_details.sql

-- 4. ERP 客户扩展表
-- 执行：silver_erp_cust_az12.sql

-- 5. ERP 地理位置表
-- 执行：silver_erp_loc_a101.sql

-- 6. ERP 产品类别表
-- 执行：silver_erp_px_cat_g1v2.sql

SELECT '========== Silver 层全量清洗执行完成 ==========' AS msg;
