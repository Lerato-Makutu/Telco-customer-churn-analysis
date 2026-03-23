# Telco Customer Churn Analysis

## Project Overview
This project analyzes telco customer behavior to understand churn patterns, identify high-risk customer segments, and quantify revenue impact from churn.  
SQL was used for data analysis and Tableau for visualizing insights through an interactive dashboard.

## Objectives
- Understand customer demographics and behavior
- Determine popular services and contracts
- Identify churned customers and calculate churn rates
- Analyze churn reasons
- Quantify revenue lost due to churn
- Provide recommendations to reduce churn

## Dataset
**Telco Customer Churn (Kaggle)**  
- 7,043 customers  
- Customer demographics, account info, services, and churn labels  

**Key fields:**  
`customer_id`, `gender`, `tenure_months`, `contract`, `payment_method`, `monthly_charges`, `total_charges`, `services`, `churn_label`, `churn_reason`

## Tools Used
- SQL / MySQL  
- Tableau  
- GitHub

## Key Insights

**Customer Overview**  
- Total customers: 7,043  
- Churned: 1,869 (26.5%)  
- Gender: 50.3% male, 49.7% female  
- Average tenure: 32.37 months  
- Average monthly charges: R64.76  

**Account & Service Behavior**  
- Common contracts: Month-to-month, Two-year, One-year  
- Month-to-month has highest churn: 42.71%  
- Two-year has lowest churn: 2.85%  
- Most used services: Phone, Internet, Streaming TV  
- Highest churn services: Internet, Multiple Lines, Streaming TV  

**City-Level & Service Analysis**  
- Top cities by churned customers: Los Angeles, San Diego, San Francisco  
- Revenue lost is highest in cities with high churn volume and high total charges  

**Churn Analysis**  
- Overall churn rate: 26.58%  
- Common churn reasons: Price, Service quality, Competitor, Customer service, Unknown  
- Highest churn for 0–12 months tenure: 47.68%  

## Business Recommendations
- Target month-to-month customers for retention campaigns  
- Improve quality of high-churn services  
- Address pricing concerns with competitive packages  
- Focus on high-value customers in high-churn cities  
- Regularly analyze churn reasons to adjust strategies

## SQL Analysis
- Data preparation and cleaning  
- Customer overview and service usage  
- Churn analysis and revenue impact  
- City-level and service-level breakdowns  

**SQL queries:** [View SQL Analysis](images/churn_analysis_results.png)

## Tableau Dashboard
- Total and churned customers by category  
- Service usage patterns and churn rates  
- Churn reasons and revenue lost  
- City-level churn and service impact  

**Dashboard:** [View on Tableau Public](images/dashboard_screenshot.png)

## Conclusion
Churned customers represent a minority but account for significant revenue loss.  
Month-to-month contracts, multiple service users, and customers moving to competitors contribute most to revenue loss.  
Targeted retention strategies, service improvements, and pricing adjustments can reduce churn and protect revenue.
<img width="468" height="646" alt="image" src="https://github.com/user-attachments/assets/dbdb86e7-5966-42c9-92b6-9339643e4d60" />
