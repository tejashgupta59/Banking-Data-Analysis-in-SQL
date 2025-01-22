SELECT DATE(transaction_date) AS dates, 
ROUND(SUM(amount),2) AS transaction_volume 
FROM transactions
WHERE transaction_date>=DATE_SUB(CURDATE(), INTERVAL 1 month) 
GROUP BY  dates
ORDER BY dates;




