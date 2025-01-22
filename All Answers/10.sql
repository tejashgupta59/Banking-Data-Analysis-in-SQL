  SELECT 
    c.customer_id, 
    YEAR(t.transaction_date) AS year, 
    MONTH(t.transaction_date) AS month,
    ROUND(AVG(a.balance), 3) AS avg_balance_per_customer
FROM accounts as a
INNER JOIN customers c ON a.customer_id = c.customer_id
INNER JOIN transactions t ON t.account_number = a.account_number
WHERE 
    t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) -- > 2023-7-11
    AND t.transaction_date = (
        SELECT MAX(t2.transaction_date)
        FROM transactions t2
        WHERE t2.account_number = t.account_number
        AND YEAR(t2.transaction_date) = YEAR(t.transaction_date)
        AND MONTH(t2.transaction_date) = MONTH(t.transaction_date))
GROUP BY 
    c.customer_id, 
    YEAR(t.transaction_date), 
    MONTH(t.transaction_date)
    order by  MONTH(t.transaction_date), YEAR(t.transaction_date);




