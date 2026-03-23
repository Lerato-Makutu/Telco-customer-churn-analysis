-- =====================================================
-- Project: Telco Customer Churn Analysis
-- Dataset: Telco Customer Churn (Kaggle)
-- Analyst: Lerato Makutu
-- Role: Data Analyst
-- Goal: Identify churn drivers and high-risk customer segments
-- =====================================================

-- =====================================================
-- SECTION 1: DATA SETUP
-- Creating a working staging table from the dataset
-- =====================================================

CREATE TABLE telco_customer_churn_staging
LIKE telco_customer_churn;

INSERT INTO telco_customer_churn_staging
SELECT * FROM telco_customer_churn; 

SELECT *
FROM telco_customer_churn_staging;

-- =====================================================
-- SECTION 2A: DATA CLEANING AND VALIDATION
-- Standardise column names using snake_case
-- Creating relevent tables from the main dataset for joins
-- =====================================================

-- Checking for duplicates

SELECT customer_id, COUNT(*) AS occurrences
FROM telco_customer_churn_staging
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Checking for missing values

SELECT COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN tenure_months IS NULL THEN 1 ELSE 0 END) AS missing_tenure,
    SUM(CASE WHEN contract IS NULL THEN 1 ELSE 0 END) AS missing_contract,
    SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS missing_payment_method,
    SUM(CASE WHEN monthly_charges IS NULL THEN 1 ELSE 0 END) AS missing_monthly_charges,
    SUM(CASE WHEN total_charges IS NULL THEN 1 ELSE 0 END) AS missing_total_charges,
    SUM(CASE WHEN churn_reason IS NULL OR churn_reason = '' THEN 1 ELSE 0 END) AS missing_churn_reason
FROM telco_customer_churn_staging;

-- Invalid values check (financial data)

SELECT *
FROM charges
WHERE monthly_charges < 0 OR total_charges < 0;

-- DATA QUALITY SUMMARY
-- In addition to the checks above, all remaining columns
-- were reviewed for completeness and consistency.
-- No significant data quality issues were identified
-- beyond those addressed, indicating that the dataset
-- was suitable for further analysis.

-- =====================================================
-- SECTION 2B: DATA PREPARATION (NORMALISATION)
-- Standardise column names using snake_case
-- Creating relevent tables from the main dataset for joins
-- =====================================================

-- Standardise column names using snake_case

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Senior Citizen` TO senior_citizen;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Tenure Months` TO tenure_months;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Lat Long` TO lat_long;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Phone Service` TO phone_service;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Multiple Lines` TO multiple_lines;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Internet Service` TO internet_service;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Online Security` TO online_security;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Online Backup` TO online_backup;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Device Protection` TO device_protection;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Tech Support` TO tech_support;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Streaming TV` TO streaming_tv;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Streaming Movies` TO streaming_movies;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Paperless Billing` TO paperless_billing;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Payment Method` TO payment_method;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Monthly Charges` TO monthly_charges;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Total Charges` TO total_charges;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Churn Label` TO churn_label;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Churn value` TO churn_value;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Churn Score` TO churn_score;

ALTER TABLE telco_customer_churn_staging
RENAME COLUMN `Churn Reason` TO churn_reason;

-- Verify data

SELECT *
FROM telco_customer_churn_staging;

-- Creating relevent tables from the main dataset for joins

-- CUSTOMER TABLE

CREATE TABLE customers AS
SELECT DISTINCT customer_id, gender, senior_citizen, partner, dependents
FROM telco_customer_churn_staging;

ALTER TABLE customers
RENAME COLUMN `CustomerID` TO customer_id;

ALTER TABLE customers
RENAME COLUMN `Gender` TO gender;

ALTER TABLE customers
MODIFY customer_id VARCHAR(50);

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- Verify data

SELECT *
FROM customers;

DESCRIBE customers;

-- ACCOUNT TABLE

CREATE TABLE account AS
SELECT DISTINCT customer_id, contract, tenure_months, paperless_billing, payment_method
FROM telco_customer_churn_staging;

ALTER TABLE account
MODIFY customer_id VARCHAR(50);

ALTER TABLE account 
ADD PRIMARY KEY (customer_id);

-- Verify data

SELECT *
FROM account;

DESCRIBE account;

-- SERVICES TABLE

CREATE TABLE services AS
SELECT DISTINCT customer_id, phone_service, multiple_lines, 
				internet_service, online_security, online_backup, 
                device_protection, tech_support, streaming_tv
FROM telco_customer_churn_staging;

ALTER TABLE services
MODIFY customer_id VARCHAR(50);

ALTER TABLE services
ADD PRIMARY KEY (customer_id);

-- Verify data

SELECT *
FROM services;

DESCRIBE services;

-- CHARGES TABLE

CREATE TABLE charges AS
SELECT DISTINCT customer_id, monthly_charges, total_charges
FROM telco_customer_churn_staging;

ALTER TABLE charges
MODIFY customer_id VARCHAR(50);

ALTER TABLE charges
ADD PRIMARY KEY (customer_id);

-- Verify data

SELECT *
FROM charges;

DESCRIBE charges;

-- CHURN TABLE

CREATE TABLE churn AS
SELECT DISTINCT customer_id, churn_score, churn_reason
FROM telco_customer_churn_staging;

ALTER TABLE churn
MODIFY customer_id VARCHAR(50);

ALTER TABLE churn
ADD PRIMARY KEY (customer_id);

-- Add churn_label column from staging

ALTER TABLE churn
ADD churn_label VARCHAR(50);

UPDATE churn ch
JOIN telco_customer_churn_staging t
ON ch.customer_id = t.customer_id
SET ch.churn_label = t.churn_label;

-- Verify data

SELECT *
FROM churn;

SELECT churn_label, COUNT(*) 
FROM churn
GROUP BY churn_label;

DESCRIBE churn;

-- =====================================================
-- SECTION 3: CUSTOMER OVERVIEW
-- Understand who your customers are 
-- =====================================================

-- Question: How many customers are in the dataset?

SELECT COUNT(*) AS total_customers
FROM customers;

-- Question: How many customers have churned vs non-churned

SELECT churn_label, COUNT(*) AS total
FROM telco_customer_churn_staging
GROUP BY churn_label;

-- Question: What is the customer distribution by gender

SELECT gender, COUNT(*) AS total_customers
FROM customers
GROUP BY gender
ORDER BY gender DESC;

-- Question: Average tenure and charges?

SELECT  
    ROUND(AVG(a.tenure_months),2) AS avg_tenure,
    ROUND(AVG(c.monthly_charges),2) AS avg_monthly_charges
FROM account a
JOIN charges c 
ON a.customer_id = c.customer_id;

-- Question: Average tenure by gender?

SELECT 
	 c.gender,
    ROUND(AVG(a.tenure_months),2) AS avg_tenure
	FROM customers c
    JOIN account a 
    ON c.customer_id = a.customer_id
    GROUP BY gender;

-- =====================================================
-- SECTION 4: ACCOUNT AND SERVICE BEHAVIOUR
-- Understand how customers interact with the company’s services and plans
-- =====================================================

-- Question: What types of contracts do customers choose?

SELECT contract, COUNT(*) AS total_customers
FROM account
GROUP BY contract
ORDER BY total_customers DESC;

-- Question: How does churn vary by contract type?

SELECT 
    a.contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN t.churn_label = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN t.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS churn_rate
FROM account a
JOIN telco_customer_churn_staging t 
ON a.customer_id = t.customer_id
GROUP BY a.contract
ORDER BY churn_rate DESC;

-- Question: Service usage and churn comparison
-- This query compares customer usage across services
-- and highlights churned customers and rate for each service

-- Question: Which services have the highest churn rates?

SELECT 'Phone Service' AS service,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM services s
JOIN churn ch ON s.customer_id = ch.customer_id
WHERE s.phone_service = 'Yes'

UNION ALL

SELECT 'Internet Service',
       COUNT(*),
       SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END),
       ROUND(SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2)
FROM services s
JOIN churn ch ON s.customer_id = ch.customer_id
WHERE s.internet_service != 'No'

UNION ALL

SELECT 'Streaming TV',
       COUNT(*),
       SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END),
       ROUND(SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2)
FROM services s
JOIN churn ch ON s.customer_id = ch.customer_id
WHERE s.streaming_tv = 'Yes'

UNION ALL

SELECT 'Multiple Lines',
       COUNT(*),
       SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END),
       ROUND(SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2)
FROM services s
JOIN churn ch ON s.customer_id = ch.customer_id
WHERE s.multiple_lines = 'Yes'

UNION ALL

SELECT 'Online Security',
       COUNT(*),
       SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END),
       ROUND(SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2)
FROM services s
JOIN churn ch ON s.customer_id = ch.customer_id
WHERE s.online_security = 'Yes'

UNION ALL

SELECT 'Online Backup',
       COUNT(*),
       SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END),
       ROUND(SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2)
FROM services s
JOIN churn ch ON s.customer_id = ch.customer_id
WHERE s.online_backup = 'Yes'

UNION ALL

SELECT 'Device Protection',
       COUNT(*),
       SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END),
       ROUND(SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2)
FROM services s
JOIN churn ch ON s.customer_id = ch.customer_id
WHERE s.device_protection = 'Yes'

UNION ALL

SELECT 'Tech Support',
       COUNT(*),
       SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END),
       ROUND(SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2)
FROM services s
JOIN churn ch ON s.customer_id = ch.customer_id
WHERE s.tech_support = 'Yes'
ORDER BY churn_rate DESC;

-- =====================================================
-- SECTION 5A: CITY-LEVEL ANALYSIS
-- Understand customer distribution, churn, and revenue impact by city
-- =====================================================

-- Churn per city (number of churned customers)

SELECT city, state, COUNT(*) AS churned_customers
FROM telco_customer_churn_staging
WHERE churn_label = 'Yes'
GROUP BY city, state
ORDER BY churned_customers DESC;

-- Total revenue lost per city 

SELECT t.city, t.state,
	COUNT(*) AS churned_customers,
	ROUND(SUM(c.total_charges), 2) AS total_revenue_lost
FROM telco_customer_churn_staging t
JOIN charges c
    ON t.customer_id = c.customer_id
JOIN churn ch
    ON t.customer_id = ch.customer_id
    WHERE ch.churn_label = 'Yes'
GROUP BY t.city, t.state
ORDER BY total_revenue_lost DESC;

-- =====================================================
-- SECTION 5B: CITY × SERVICE ANALYSIS
-- Churned customers and revenue impact by city and service
-- =====================================================

SELECT t.city, t.state,
COUNT(*) AS churned_customers,
ROUND(SUM(c.total_charges),2) AS total_revenue_lost,
    SUM(CASE WHEN s.phone_service='Yes' THEN 1 ELSE 0 END) AS phone_service_users,
    SUM(CASE WHEN s.multiple_lines='Yes' THEN 1 ELSE 0 END) AS multiple_lines_users,
    SUM(CASE WHEN s.internet_service != 'No' THEN 1 ELSE 0 END) AS internet_service_users,
    SUM(CASE WHEN s.online_security='Yes' THEN 1 ELSE 0 END) AS online_security_users,
    SUM(CASE WHEN s.online_backup='Yes' THEN 1 ELSE 0 END) AS online_backup_users,
    SUM(CASE WHEN s.device_protection='Yes' THEN 1 ELSE 0 END) AS device_protection_users,
    SUM(CASE WHEN s.tech_support='Yes' THEN 1 ELSE 0 END) AS tech_support_users,
    SUM(CASE WHEN s.streaming_tv='Yes' THEN 1 ELSE 0 END) AS streaming_tv_users
FROM telco_customer_churn_staging t
JOIN churn ch
    ON t.customer_id = ch.customer_id
JOIN services s
    ON t.customer_id = s.customer_id
JOIN charges c
    ON t.customer_id = c.customer_id
    WHERE ch.churn_label = 'Yes'
GROUP BY t.city, t.state
ORDER BY churned_customers DESC;

-- =====================================================
-- SECTION 6: CHURN ANALYSIS
-- Understanding why customers are leaving
-- =====================================================

-- Question: What is the overall churn rate?

SELECT  COUNT(*) AS total_customers,
		SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
		ROUND(SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM telco_customer_churn_staging;

-- Question: What are the most common churn reasons?

SELECT churn_reason, COUNT(*) AS total_customers
FROM churn
WHERE churn_label = 'Yes'
GROUP BY churn_reason
ORDER BY total_customers DESC;

-- group the above reasons into categories

SELECT 
	CASE 
    WHEN churn_reason LIKE "%Don't know%" THEN 'Unknown'
    WHEN churn_reason LIKE '%Attitude%' THEN 'Customer_service'
    WHEN churn_reason LIKE '%Competitor%' OR churn_reason LIKE '%Moved%' THEN 'Competitor'
    WHEN churn_reason LIKE '%dissatisfaction%' OR churn_reason LIKE '%reliability%' OR churn_reason LIKE '%Lack%' OR churn_reason LIKE '%Poor%' OR churn_reason LIKE '%Limited%' THEN 'Service quality'
    WHEN churn_reason LIKE '%Price%' OR churn_reason LIKE '%Charges%' THEN 'Price'
    ELSE 'Other'
    END AS churn_category_calc,
COUNT(*) AS total_customers
FROM churn
WHERE churn_label = 'Yes'
GROUP BY churn_category_calc
ORDER BY total_customers DESC;

-- Add column  for churn table (churn_category)

ALTER TABLE churn
ADD churn_category VARCHAR(50);

UPDATE churn
SET churn_category =
CASE 
    WHEN churn_label = 'No' THEN NULL
	WHEN churn_reason LIKE "%Don't know%" THEN 'Unknown'
    WHEN churn_reason LIKE '%Attitude%' THEN 'Customer_service'
    WHEN churn_reason LIKE '%Competitor%' OR churn_reason LIKE '%Moved%' THEN 'Competitor'
	WHEN churn_reason LIKE '%dissatisfaction%' OR churn_reason LIKE '%reliability%' OR churn_reason LIKE '%Lack%' OR churn_reason LIKE '%Poor%' OR churn_reason LIKE '%Limited%' THEN 'Service quality'
	WHEN churn_reason LIKE '%Price%' OR churn_reason LIKE '%Charges%' THEN 'Price'
ELSE 'Other'
END;

-- Churn reasons by contract type

SELECT a.contract, ch.churn_category, COUNT(*) AS total_customers
FROM account a
JOIN churn ch
ON a.customer_id = ch.customer_id
WHERE churn_label = 'Yes'
GROUP BY a.contract, ch.churn_category
ORDER BY total_customers DESC;	

-- Revenue lost by churn category (Monthly, Total, and Estimated future loss)

SELECT ch.churn_category, 
	ROUND(SUM(c.monthly_charges),2) AS potential_monthly_revenue_lost,
	ROUND(SUM(c.total_charges),2) AS total_revenue_lost
FROM churn ch
JOIN charges c
ON ch.customer_id = c.customer_id
WHERE churn_label = 'Yes'
GROUP BY ch.churn_category
ORDER BY potential_monthly_revenue_lost DESC;

-- Estimated customer lifetime value lost

SELECT 
    ch.churn_category,
    ROUND(SUM(c.monthly_charges * a.tenure_months),2) AS estimated_lifetime_value_lost
FROM churn ch
JOIN charges c ON ch.customer_id = c.customer_id
JOIN account a ON ch.customer_id = a.customer_id
WHERE ch.churn_label = 'Yes'
GROUP BY ch.churn_category
ORDER BY estimated_lifetime_value_lost DESC;

-- Churn by tenure group

SELECT 
    CASE
        WHEN a.tenure_months <= 12 THEN '0-1 Year'
        WHEN a.tenure_months <= 24 THEN '1-2 Years'
        ELSE '2+ Years'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN ch.churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
2) AS churn_rate
FROM account a
JOIN churn ch 
ON a.customer_id = ch.customer_id
GROUP BY tenure_group
ORDER BY churn_rate DESC;

select * from churn;
