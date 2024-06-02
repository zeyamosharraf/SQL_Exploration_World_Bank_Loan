--1. Counting Countries with World Bank Loans
select count(distinct country) as total_country from worldbank;

--2. Calculating Total Loan Amount for Each Project
-- In our analysis of World Bank loan data, we calculate the total loan amount for each project to understand the financial scope of individual initiatives. 
-- This helps in prioritizing projects, allocating resources effectively, and making informed budgeting and decision-making decisions, ensuring efficient project management and financial planning.
SELECT project_name, 
       CONCAT('$', ROUND(SUM(original_principal_amount)/1000000, 2), 'M') AS total_loan_amount 
FROM worldbank 
GROUP BY project_name;

--3. Calculating Total Original Principal Amount for All Projects
-- In our analysis of World Bank loan data, the task is to determine the total original principal amount for all projects. 
-- This calculation provides an essential snapshot of the combined financial commitment across all projects, offering insights into their overall financial scale. 
-- This information is valuable for budgeting, resource allocation, and understanding the collective financial impact of World Bank initiatives, aiding in informed decision-making and financial planning.
select CONCAT('$', ROUND(SUM(original_principal_amount)/100000000, 2), 'B') as total_amount
from worldbank;

--4. Calculating Average Repaid to IDA for Each Region
-- In our analysis of World Bank loan data, we calculate the average amount repaid to the International Development Association (IDA) for each region. 
-- This task is valuable as it allows us to assess the regional repayment performance and financial sustainability of IDA projects.
-- These insights can guide decisions related to funding allocation and project prioritization.
select region, CONCAT('$', ROUND(AVG(repaid_ida)/1000000,2), 'M') as AvgRepaidToIDA
from worldbank
group by region;

--5. Identifying Country with Highest Repaid to IDA Ratio
--In our World Bank loan data analysis, we aim to find the country with the highest ratio of repaid amounts to the International Development Association (IDA) compared to the original principal amounts.
--We focus on projects with a "Fully Repaid" credit status. 
--This task provides insights into effective loan management and highlights countries with successful repayment strategies.
SELECT country, Round(MAX(repaid_ida / original_principal_amount), 2) AS MaxRepaidToPrincipalRatio 
FROM worldbank
WHERE credit_status = 'Fully Repaid' and original_principal_amount !=0
GROUP BY country
order by MaxRepaidToPrincipalRatio desc;

--6. Counting Projects by Credit Status for Each Country
-- In our analysis of World Bank loan data, we aim to determine, for each country, the number of projects with different credit status values, such as "Active," "Fully Repaid," "Cancelled," and others. 
-- This task provides a comprehensive view of the distribution of projects across various credit statuses within each country, enabling us to assess the progress and status of projects. 
-- This information is essential for tracking project performance and managing the diverse range of projects effectively.
select country, credit_status, count(credit_status) as projectcount
from worldbank
group by country, credit_status
order by projectcount desc
limit 10;


--7. Counting Countries with World Bank Loans by Region
--In our World Bank loan data analysis, we count the number of countries within each region that have received loans from the World Bank. 
--This task offers insights into regional lending distribution and the scope of World Bank financial support across different regions. 
--Understanding this distribution is vital for regional financial assessment and decision-making.

select region, count(distinct country) as countries
from worldbank
group by region
order by countries desc;

--8. Counting Fully Repaid Projects by Region
-- In our analysis of World Bank loan data, we calculate the total number of fully repaid projects (where "Credit Status" equals 'Fully Repaid') for each region. 
-- This task allows us to assess the success of repayment within various regions. 
-- By utilizing the provided query, we group the data by region and sum the projects with a "Fully Repaid" credit status. 
-- This information provides valuable insights into regional project performance and financial sustainability within the World Bank ecosystem, aiding in regional decision-making and resource allocation.
select region, sum(Case when credit_status = 'Fully Repaid' then 1 else 0 end) as paid
from worldbank
group by region
order by paid desc;

--9. Identifying Projects with the Highest "Due to IDA"
-- In our World Bank loan data analysis, we're searching for projects with the highest "Due to IDA" amounts.
-- We also want to determine the corresponding "Country" and "Effective Date" for these projects. 
-- This task helps us identify projects with significant financial commitments to the International Development Association (IDA), providing insights into impactful projects and their financial details.
SELECT country, 
       project_name, 
       effective_date, 
       CONCAT('$', ROUND(Due_ida/1000000, 2), 'M') AS Due_to_IDA_amount
FROM worldbank
ORDER BY Due_ida DESC
LIMIT 5;


--10. Identifying Top 5 Countries with Highest Repaid to Principal Ratio
-- In our World Bank loan data analysis, we aim to find the top 5 countries with the highest "Repaid to IDA" to "Original Principal Amount" ratio for projects that are not fully repaid. 
-- This task reveals countries with efficient loan repayment strategies and is essential for financial assessment and sharing best practices.

SELECT country, 
       CONCAT('$', round((sum(repaid_ida) / sum(original_principal_amount)), 2), 'B') AS ratio_repaid_to_original_principal_amount
FROM worldbank
WHERE credit_status <> 'Fully Repaid'
GROUP BY country
order by (sum(repaid_ida) / sum(original_principal_amount)) desc
limit 5;

--11.  Identifying Top 5 Countries with the Highest Total Loan Amount
-- In our World Bank loan data analysis, we're focused on determining the top 5 countries with the highest total loan amounts. 
-- This task is essential to understand the countries with significant financial commitments. 
-- By employing the provided query to sum the "Original Principal Amount" and subtract the "Cancelled Amount," we calculate the total loan amount in billions for each country. 
-- This information provides insights into the financial scale of World Bank loans in different countries, guiding resource allocation and financial assessment.
SELECT country, 
       CONCAT('$', 
              ROUND(SUM(CAST(original_principal_amount AS DECIMAL(20,2))) / 1000000000, 2) - 
              ROUND(SUM(CAST(cancelled_amount AS DECIMAL(20,2))) / 1000000000, 2), 
              'B') AS all_loan_amount
FROM worldbank
GROUP BY country
ORDER BY ROUND(SUM(CAST(original_principal_amount AS DECIMAL(20,2))) / 1000000000, 2) - 
         ROUND(SUM(CAST(cancelled_amount AS DECIMAL(20,2))) / 1000000000, 2) DESC
LIMIT 5;

-- 12. Identifying Top 5 Countries with the Highest Due Amount In our World Bank loan data analysis, we aim to determine the top 5 countries with the highest "Due to IDA" amounts. 
-- This task is crucial to understand the countries with significant outstanding obligations to the International Development Association (IDA). 
-- By utilizing the provided query to sum the "Due to IDA" amounts for each country, we gain insights into countries with substantial financial commitments. 
-- This information is essential for financial assessment and tracking outstanding financial obligations.

SELECT country, 
       CONCAT('$', 
              ROUND(SUM(Due_ida) / 1000000000, 2), 'B') AS all_loan_amount
FROM worldbank
GROUP BY country
ORDER BY ROUND(SUM(Due_ida) / 1000000000, 2) DESC
LIMIT 5;




