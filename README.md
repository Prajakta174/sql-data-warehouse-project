# SQL Data Warehouse & Exploratory Data Analysis

An end-to-end data project that combines **SQL Data Warehousing** with **Python-based Exploratory Data Analysis (EDA)**. The project transforms raw CRM and ERP data into a structured analytical data warehouse and uses the Gold layer for data analysis, visualization, and business insights.

---

## Project Overview

This project is divided into two major parts:

### 1. Data Warehouse

A modern SQL Data Warehouse is developed using SQL Server following the **Bronze-Silver-Gold architecture**.

The data is:

- Extracted from CRM and ERP source systems
- Loaded into the Bronze layer
- Cleaned and transformed in the Silver layer
- Integrated into business-ready Gold layer tables

### 2. Exploratory Data Analysis

The Gold layer data is imported into Python using **SQLAlchemy and Pandas**.

EDA is performed to understand:

- Sales performance
- Product performance
- Customer patterns
- Pricing
- Sales trends
- Relationships between numerical variables

The results are presented using **Matplotlib and Seaborn**.

---

# 1. Data Warehouse

## Architecture

The project follows a **Bronze-Silver-Gold architecture**:

```text
                    CRM Sources
                        |
                        |
                    ERP Sources
                        |
                        v
                +---------------+
                | Bronze Layer  |
                |   Raw Data    |
                +---------------+
                        |
                        v
                +---------------+
                | Silver Layer  |
                | Cleaned Data  |
                +---------------+
                        |
                        v
                +---------------+
                |  Gold Layer   |
                | Business Data |
                +---------------+
                        |
                        v
                 Python EDA
```
