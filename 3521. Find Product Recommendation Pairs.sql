SELECT
  P1.product_id AS product1_id,              -- Select the first product in the pair
  P2.product_id AS product2_id,              -- Select the second product in the pair
  PI1.category AS product1_category,         -- Get the category of the first product
  PI2.category AS product2_category,         -- Get the category of the second product
  COUNT(*) AS customer_count                 -- Count how many customers purchased both products
FROM ProductPurchases P1
JOIN ProductPurchases P2 
  ON P1.user_id = P2.user_id                -- Join purchases by the same user
  AND P1.product_id < P2.product_id         -- Ensure unique and ordered product pairs (avoid duplicates like (A,B) and (B,A))
LEFT JOIN ProductInfo PI1 
  ON P1.product_id = PI1.product_id         -- Join to get category info for product 1
LEFT JOIN ProductInfo PI2 
  ON P2.product_id = PI2.product_id         -- Join to get category info for product 2
GROUP BY 
  P1.product_id, P2.product_id, PI1.category, PI2.category -- Group by product pairs and their categories
HAVING 
  COUNT(*) >= 3                             -- Only include product pairs purchased by at least 3 users
ORDER BY 
  customer_count DESC,                      -- Order by number of customers (descending)
  product1_id, product2_id;                 -- Tie-breaker: order by product IDs ascending
