Telco Customer Churn Analysis (Kaggle Dataset)
Project Overview
This project analyzes telco customer behavior to understand churn patterns, identify high-risk customer segments, and quantify revenue impact from churn. The analysis was conducted using SQL for data exploration and churn analysis, and Tableau to visualize customer behavior, service usage, and churn insights through an interactive dashboard.
Objectives
The goal of this analysis was to:
•	Understand overall customer demographics and behavior
•	Determine which services and contracts are most popular
•	Identify churned customers and calculate churn rates
•	Analyze reasons for churn and categorize them
•	Quantify revenue lost due to churn
•	Provide business recommendations to reduce churn and retain high-value customers
Dataset
Dataset used: Telco Customer Churn (Kaggle)
The dataset contains customer records, service usage, account information, and churn details:
•	7,043 customers
•	Customer demographics (gender, age, partner/dependent status)
•	Account information (contract type, tenure, payment method)
•	Service subscriptions (phone, internet, streaming, tech support, etc.)
•	Monthly and total charges
•	Churn labels, scores, and reasons
Key fields include:
•	customer_id
•	gender
•	tenure_months
•	contract
•	payment_method
•	monthly_charges
•	total_charges
•	services (phone, internet, streaming, tech support, etc.)
•	churn_label
•	churn_reason
Tools Used
•	SQL / MySQL
•	Tableau
•	GitHub
Key Insights
Customer Overview
•	Total customers: 7,043
•	Churned vs non-churned: 1,869 churned (26.5%)
•	Gender distribution: 50.3% male, 49.7% female
•	Average tenure: 32.37 months
•	Average monthly charges: R64.76
•	Average tenure by gender: Males slightly higher than females
Account & Service Behavior
Most common contract types:
1.	Month-to-month
2.	Two-year
3.	One-year
Churn by contract type:
•	Month-to-month customers have the highest churn rate (42.71%)
•	Two-year customers have the lowest churn rate (2.85%)
Service usage & churn:
•	Most used services: Phone, Internet, Streaming TV
•	Services with highest churn rates: Internet Service, Multiple Lines, Streaming TV
City-Level & Service Analysis
•	Top cities by churned customers: Los Angeles, San Diego and San Francisco 
•	Revenue lost per city: Highest in cities with high churn volume and high average total charges
•	Service usage among churned customers: Internet, phone, and streaming services are most commonly held by churned customers

Churn Analysis
Overall churn rate: 26.58%
Most common churn reasons:
•	Price
•	Service quality
•	Competitor
•	Customer service
•	Unknown
Churn by contract type: Month-to-month customers are most impacted by service quality and price issues.
Revenue impact by churn category:
•	Potential monthly revenue lost: Highest from customers leaving due to competitor
•	Total revenue lost: Highest from customers leaving due to competitor
•	Estimated customer lifetime value lost: Most significant for long-tenure customers leaving due to competitor
Churn by tenure group:
•	Highest churn rate among customers with 0–12 months tenure (47.68%)
•	Churn decreases with longer tenure
Business Recommendations
•	Target month-to-month customers for retention campaigns with special offers or loyalty programs
•	Improve monitoring and quality of high-churn services such as internet, streaming TV, and multiple lines
•	Address pricing concerns through competitive packages or discounts for long-tenure customers
•	Focus on high-value customers in high-churn cities to prevent revenue loss
•	Analyze churn reasons regularly to identify emerging patterns and adjust strategies
SQL Analysis
The full SQL queries used in this analysis can be found here:
[View SQL Analysis]

These queries cover:
•	Data preparation and cleaning
•	Customer overview and service usage
•	Churn analysis and revenue impact
•	City-level and service-level breakdowns
Churn Analysis Dashboard
After performing the SQL queries, an interactive Tableau dashboard was created to visualize:
•	Total customers and churned customers by category
•	Service usage patterns and churn rates
•	Churn reasons and revenue lost
•	City-level churn and service impact
Explore the interactive dashboard here: [View on Tableau Public]
Conclusion
While churned customers represent a minority of the total, they account for significant revenue loss. Churn is concentrated among month-to-month contracts, customers using multiple services (internet, streaming), and customers moving to competitors or service quality concerns.
By implementing targeted retention strategies, improving service quality, and addressing pricing issues, telecom companies can reduce churn and protect revenue.
<img width="468" height="637" alt="image" src="https://github.com/user-attachments/assets/43c2d0f2-4268-48bb-8841-1d27d228a9de" />
