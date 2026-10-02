# Naming Conventions

This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse.

## Table of Contents
1. [通用原则](#通用原则)
2. [表命名规范](#表命名规范)
    - [Bronze层规则](#bronze层规则)
    - [Silver层规则](#silver层规则)
    - [Gold层规则](#gold层规则)
3. [字段命名规范](#字段命名规范)
    - [代理键](#代理键)
    - [技术字段](#技术字段)
4. [存储过程命名规范](#存储过程命名规范)

---

## 通用原则
- 命名规范：使用蛇形命名法 snake_case，全部小写，下划线 `_` 分隔单词。
- 语言：所有对象名称使用英文。
- 规避保留字：不要使用SQL保留关键字作为对象名称。

## 表命名规范
### Bronze层规则
- 所有名称必须以源系统名称开头，表名与源系统原始表名保持一致，不重命名。
- `<sourcesystem>_<entity>`
    - `<sourcesystem>`：源系统名称（例如 `crm`、`erp`）。
    - `<entity>`：源系统内原始表名称。
    - 示例：`crm_customer_info` → CRM系统的客户信息表。

### Silver层规则
- 所有名称必须以源系统名称开头，表名与源系统原始表名保持一致，不重命名。
- `<sourcesystem>_<entity>`
    - `<sourcesystem>`：源系统名称（例如 `crm`、`erp`）。
    - `<entity>`：源系统内原始表名称。
    - 示例：`crm_customer_info` → CRM系统的客户信息表。

### Gold层规则
- 所有表使用贴合业务含义的名称，以类别前缀开头。
- `<category>_<entity>`
    - `<category>`：描述表的类型，如 `dim`（维度表）或 `fact`（事实表）。
    - `<entity>`：贴合业务域的表描述名称（例如 `customers`、`products`、`sales`）。
    - 示例：
        - `dim_customers` → 客户数据维度表。
        - `fact_sales` → 存储销售交易的事实表。

#### 类别前缀说明表
| Pattern | Meaning | Example(s) |
|---|---|---|
| `dim_` | 维度表 | `dim_customer`, `dim_product` |
| `fact_` | 事实表 | `fact_sales` |
| `report_` | 报表表 | `report_customers`, `report_sales_monthly` |

## 字段命名规范
### 代理键
- 维度表所有主键，必须使用后缀 `_key`。
- `<table_name>_key`
    - `<table_name>`：该键所属表/实体名称。
    - `_key`：后缀，表示该列为代理键。
    - 示例：`customer_key` → `dim_customers` 表中的代理键。

### 技术字段
- 所有技术字段必须以前缀 `dwh_` 开头，后面描述字段用途。
- `dwh_<column_name>`
    - `dwh`：专门用于系统生成元数据的前缀。
    - `<column_name>`：描述字段用途。
    - 示例：`dwh_load_date` → 系统生成字段，记录数据加载日期。

## 存储过程命名规范
- 所有用于数据加载的存储过程，遵循命名格式：
- `load_<layer>`
    - `<layer>`：被加载的分层，`bronze` / `silver` / `gold`。
    - 示例：
        - `load_bronze` → 将数据加载至Bronze层的存储过程。
        - `load_silver` → 将数据加载至Silver层的存储过程。
