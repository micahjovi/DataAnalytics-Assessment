SELECT 
    u.id AS customer_id,
    u.name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE())) * 12 * 
        (AVG(s.confirmed_amount) * 0.001) / 100 AS estimated_clv
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
WHERE 
    s.transaction_date IS NOT NULL AND
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) > 0
GROUP BY 
    u.id, u.name, tenure_months
ORDER BY 
    estimated_clv DESC;