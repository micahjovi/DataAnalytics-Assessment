WITH customer_transactions AS (
    SELECT 
        s.owner_id,
        COUNT(s.id) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(u.date_joined), CURRENT_DATE()) AS months_active,
        COUNT(s.id) / TIMESTAMPDIFF(MONTH, MIN(u.date_joined), CURRENT_DATE()) AS avg_transactions_per_month
    FROM 
        savings_savingsaccount s
    JOIN 
        users_customuser u ON s.owner_id = u.id
    WHERE 
        s.transaction_date IS NOT NULL
    GROUP BY 
        s.owner_id
    HAVING 
        months_active > 0
)

SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    AVG(avg_transactions_per_month) AS avg_transactions_per_month
FROM 
    customer_transactions
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;