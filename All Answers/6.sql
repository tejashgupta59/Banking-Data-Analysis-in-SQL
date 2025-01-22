SELECT a.customer_id, a.account_number, 
YEAR(t.transaction_date) AS transaction_year, 
MONTH(t.transaction_date) AS transaction_month,
    COUNT(t.transaction_id) AS transaction_count,
    COUNT(t.transaction_id) / 12 AS avg_transactions_per_month_last_year
FROM transactions t
JOIN accounts a ON t.account_number = a.account_number
WHERE t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY a.customer_id, a.account_number, transaction_year, transaction_month
ORDER BY a.customer_id, a.account_number, transaction_year, transaction_month;




