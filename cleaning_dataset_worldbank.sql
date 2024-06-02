---Create the database
create database worldbank;

-- Create the table and columns
CREATE TABLE worldbank (
    "end_period" date,
    "credit_number" VARCHAR(50),
    "region" VARCHAR(255),
    "country_code" VARCHAR(10),
    "country" VARCHAR(255),
    "credit_status" VARCHAR(255),
    "project_id" VARCHAR(50),
    "project_name" VARCHAR(255),
    "original_principal_amount" NUMERIC(20, 2),
    "cancelled_amount" NUMERIC(20, 2),
    "undisbursed_amount" NUMERIC(20, 2),
    "disbursed_amount" NUMERIC(20, 2),
    "repaid_ida" NUMERIC(20, 2),
    "due_ida" NUMERIC(20, 2),
    "borrower_obligation" NUMERIC(20, 2),
    "board_approval_date" date,
    "effective_date" date
);

-- view the datasets
select * from worldbank;

-- Remove the unncessary column from the datasets
Alter table worldbank
drop column country_code,
drop column borrower_obligation;

-- Identifying Duplicate Data
WITH RankedDuplicates AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                end_period, credit_number, region, country, credit_status, project_id, project_name,
                original_principal_amount, cancelled_amount, undisbursed_amount, disbursed_amount, repaid_ida,
                due_ida, board_approval_date, effective_date
            ORDER BY 
                (SELECT NULL)  -- Arbitrary ordering
        ) as rn
    FROM 
        worldbank
)
select rn from RankedDuplicates where rn> 1;

-- Removing Duplicate Data
WITH RankedDuplicates AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                end_period, credit_number, region, country, credit_status, project_id, project_name,
                original_principal_amount, cancelled_amount, undisbursed_amount, disbursed_amount, repaid_ida,
                due_ida, board_approval_date, effective_date
            ORDER BY 
                (SELECT NULL)  -- Arbitrary ordering
        ) as rn
    FROM 
        worldbank
)
DELETE FROM worldbank
WHERE (end_period, credit_number, region, country, credit_status, project_id, project_name,
       original_principal_amount, cancelled_amount, undisbursed_amount, disbursed_amount, repaid_ida,
       due_ida, board_approval_date, effective_date) IN (
    SELECT 
        end_period, credit_number, region, country, credit_status, project_id, project_name,
        original_principal_amount, cancelled_amount, undisbursed_amount, disbursed_amount, repaid_ida,
        due_ida, board_approval_date, effective_date
    FROM 
        RankedDuplicates
    WHERE rn > 1
);


-- Identifying Missing Data
SELECT
    SUM(CASE WHEN end_period IS NULL THEN 1 ELSE 0 END) AS end_period_nulls,
    SUM(CASE WHEN credit_number IS NULL THEN 1 ELSE 0 END) AS credit_number_nulls,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS region_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN credit_status IS NULL THEN 1 ELSE 0 END) AS credit_status_nulls,
    SUM(CASE WHEN project_id IS NULL THEN 1 ELSE 0 END) AS project_id_nulls,
    SUM(CASE WHEN project_name IS NULL THEN 1 ELSE 0 END) AS project_name_nulls,
    SUM(CASE WHEN original_principal_amount IS NULL THEN 1 ELSE 0 END) AS original_principal_amount_nulls,
    SUM(CASE WHEN cancelled_amount IS NULL THEN 1 ELSE 0 END) AS cancelled_amount_nulls,
    SUM(CASE WHEN undisbursed_amount IS NULL THEN 1 ELSE 0 END) AS undisbursed_amount_nulls,
    SUM(CASE WHEN disbursed_amount IS NULL THEN 1 ELSE 0 END) AS disbursed_amount_nulls,
    SUM(CASE WHEN repaid_ida IS NULL THEN 1 ELSE 0 END) AS repaid_ida_nulls,
    SUM(CASE WHEN due_ida IS NULL THEN 1 ELSE 0 END) AS due_ida_nulls,
    SUM(CASE WHEN board_approval_date IS NULL THEN 1 ELSE 0 END) AS board_approval_date_nulls,
    SUM(CASE WHEN effective_date IS NULL THEN 1 ELSE 0 END) AS effective_date_nulls
FROM 
    worldbank;

-- Handling Missing Data
DELETE FROM worldbank
WHERE end_period IS NULL
   OR credit_number IS NULL
   OR region IS NULL
   OR country IS NULL
   OR credit_status IS NULL
   OR project_id IS NULL
   OR project_name IS NULL
   OR original_principal_amount IS NULL
   OR cancelled_amount IS NULL
   OR undisbursed_amount IS NULL
   OR disbursed_amount IS NULL
   OR repaid_ida IS NULL
   OR due_ida IS NULL
   OR board_approval_date IS NULL
   OR effective_date IS NULL;


