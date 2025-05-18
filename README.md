# DataAnalytics-Assessment
Question 1: High-Value Customers with Multiple Products
Approach
I needed to identify customers who have both savings plans AND investment plans, with a focus on funded accounts. The approach involved:

Joining key tables: I joined users_customuser, plans_plan, and savings_savingsaccount to connect customers with their plans and transactions.
Conditional counting: Used COUNT(DISTINCT CASE WHEN...) to count the number of unique savings plans and investment plans per customer. The DISTINCT is crucial to avoid counting the same plan multiple times if it has multiple transactions.
Filtering for funded plans: Added the condition s.confirmed_amount > 0 to ensure we're only considering funded plans.
HAVING clause: Used HAVING savings_count > 0 AND investment_count > 0 to filter for customers with at least one of each plan type.
Converting kobo to main currency: Divided by 100 as the hint mentioned amounts are stored in kobo.

Challenges

Understanding the relationship between tables: The schema didn't explicitly show foreign key relationships. I inferred them from the column names and the hints provided.
Determining "funded" status: I assumed "funded" meant having a positive confirmed amount in the savings table, but in a real scenario, I would verify this understanding.
Currency conversion: Needed to remember to convert kobo to the main currency unit by dividing by 100 for a more meaningful output.

Question 2: Transaction Frequency Analysis
Approach
This question required calculating transaction frequency and categorizing customers. I approached it using:

Common Table Expression (CTE): Created a CTE to first calculate each customer's transaction metrics before categorization.
Calculating months active: Used TIMESTAMPDIFF(MONTH, MIN(u.date_joined), CURRENT_DATE()) to determine how long each customer has been active.
Computing average monthly transactions: Divided total transactions by months active.
Categorization using CASE: Applied the specified frequency categories (High/Medium/Low) based on transaction rates.
Final aggregation: Grouped by category to get counts and average transaction frequencies.

Challenges

Handling edge cases: Needed to account for users with zero months active by adding a HAVING clause to avoid division by zero.
Determining transaction definition: The schema doesn't explicitly state what constitutes a transaction. I assumed each row in the savings_savingsaccount table with a transaction_date represents one transaction.
Order of categories: Used a CASE statement in the ORDER BY clause to ensure categories appear in a logical order (High → Medium → Low) rather than alphabetical order.

Question 3: Account Inactivity Alert
Approach
This question focused on identifying inactive accounts. My approach was:

Determining account activity: Used MAX(transaction_date) to find the most recent transaction for each plan.
Calculating inactivity period: Applied DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) to compute days since last activity.
Handling accounts with no transactions: Used a LEFT JOIN and included a condition to catch accounts that have never had any transactions (where last_transaction_date IS NULL).
Plan type identification: Created a CASE statement to categorize plans as either "Savings" or "Investment" based on the flags in the plans table.

Challenges

Determining active account status: The schema doesn't explicitly define what makes an account "active." I assumed active meant status_id = 1, but this would need verification in a real scenario.
Handling NULL transaction dates: Needed to account for accounts that might exist but have never had any transactions, which required careful handling in both the JOIN and the HAVING clause.
Date calculations: Ensuring the date difference calculation was measuring the correct period (days since last transaction).

Question 4: Customer Lifetime Value (CLV) Estimation
Approach
This question required implementing a CLV calculation formula. My approach included:

Calculating tenure: Used TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) to determine each customer's account age in months.
Computing transaction metrics: Counted total transactions and calculated average transaction values.
Implementing the CLV formula: Applied the formula: (transactions/tenure) × 12 × avg_profit_per_transaction.
Profit calculation: Set profit as 0.1% of transaction value (0.001 × confirmed_amount).
Currency conversion: Divided by 100 to convert from kobo to the main currency unit.

Challenges

Formula interpretation: Ensuring I correctly understood and implemented the CLV formula with the right profit calculation (0.1% of transaction value).
Handling new customers: Added a condition to filter out customers with less than one month tenure to avoid division by zero errors.
Average calculation: Determining whether to use the mean of all transactions or the sum of profits divided by transactions count (I chose the former as it seemed to match the formula description).
Data type considerations: Making sure the mathematical operations wouldn't result in integer division that could truncate decimal values.

In all questions, a fundamental challenge was interpreting a schema without complete documentation or sample data. I made reasonable assumptions based on column names and the hints provided, but in a real-world scenario, I would verify these assumptions with stakeholders or by examining sample data before finalizing the queries.
