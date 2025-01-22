SELECT DISTINCT(c.customer_id)  
FROM customers AS c 
JOIN accounts AS A
ON c.customer_id=A.customer_id
JOIN transactions AS T 
ON A.account_number=T.account_number
WHERE YEAR(transaction_date)<>2023
ORDER BY c.customer_id;




