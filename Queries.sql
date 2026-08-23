--Section 1: Sales Performance (1–6)

--1. What is the total revenue generated?

SELECT
    SUM(sales) AS total_revenue
FROM sales;

--2.What is the average daily sales?

SELECT
    AVG(sales) AS average_daily_sales
FROM sales;

--3. Which are the top 10 stores by total sales?

SELECT
    store,
    SUM(sales) AS total_sales
FROM sales
GROUP BY store
ORDER BY total_sales DESC
LIMIT 10;

--4. Which are the bottom 10 stores by total sales?

SELECT
    store,
    SUM(sales) AS total_sales
FROM sales
GROUP BY store
ORDER BY total_sales ASC
LIMIT 10;

--5. Which stores have the highest average daily sales?

SELECT
    store,
    ROUND(AVG(sales), 2) AS avg_daily_sales
FROM sales
WHERE open = 1
GROUP BY store
ORDER BY avg_daily_sales DESC
LIMIT 10;

--6. What is the average sales per customer?

SELECT
    ROUND(
        SUM(sales)::numeric / NULLIF(SUM(customers), 0),
        2
    ) AS average_sales_per_customer
FROM sales
WHERE open = 1;

--Section 2 – Customer Analysis (7–11)

--7. Which stores have served the highest number of customers?

SELECT
    store,
    SUM(customers) AS total_customers
FROM sales
WHERE open = 1
GROUP BY store
ORDER BY total_customers DESC
LIMIT 10;

--8.Which stores have the highest average customers per day?

SELECT
    store,
    ROUND(AVG(customers), 2) AS avg_customers_per_day
FROM sales
WHERE open = 1
GROUP BY store
ORDER BY avg_customers_per_day DESC
LIMIT 10;

--9. Which store has the highest sales per customer?

SELECT
    store,
    ROUND(
        SUM(sales)::numeric / NULLIF(SUM(customers), 0),
        2
    ) AS sales_per_customer
FROM sales
WHERE open = 1
GROUP BY store
ORDER BY sales_per_customer DESC
LIMIT 1;

--10. Which store has the lowest sales per customer?

SELECT
    store,
    ROUND(
        SUM(sales)::numeric / NULLIF(SUM(customers), 0),
        2
    ) AS sales_per_customer
FROM sales
WHERE open = 1
GROUP BY store
ORDER BY sales_per_customer ASC
LIMIT 1;

--11. Which stores have above-average customer traffic?

SELECT
    store,
    ROUND(AVG(customers), 2) AS avg_customers_per_day
FROM sales
WHERE open = 1
GROUP BY store
HAVING AVG(customers) > (
    SELECT AVG(customers)
    FROM sales
    WHERE open = 1
)
ORDER BY avg_customers_per_day DESC;

--Section 3 – Time Series Analysis (12–18)

--12. Which year generated the highest sales?

SELECT
    EXTRACT(YEAR FROM date) AS year,
    SUM(sales) AS total_sales
FROM sales
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY total_sales DESC
LIMIT 1;

--13. Which month generated the highest revenue?

SELECT
    EXTRACT(MONTH FROM date)::int AS month,
    ROUND(AVG(sales), 2) AS avg_daily_sales
FROM sales
WHERE open = 1
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY avg_daily_sales DESC
LIMIT 1;

--14. Which month had the highest customer footfall?

SELECT
    EXTRACT(MONTH FROM date)::int AS month,
    SUM(customers) AS total_customers
FROM sales
WHERE open = 1
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY total_customers DESC
LIMIT 1;


--15. Which day of the week generates the highest sales?

SELECT
    dayofweek,
    ROUND(AVG(sales), 2) AS avg_daily_sales
FROM sales
WHERE open = 1
GROUP BY dayofweek
ORDER BY avg_daily_sales DESC
LIMIT 1;


--16. Which day of the week attracts the most customers?

SELECT
    dayofweek,
    SUM(customers) AS total_customers
FROM sales
WHERE open = 1
GROUP BY dayofweek
ORDER BY total_customers DESC
LIMIT 1;

--17. Compare weekday vs weekend sales.

SELECT
    CASE
        WHEN dayofweek IN (6, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    SUM(sales) AS total_sales
FROM sales
WHERE open = 1
GROUP BY day_type
ORDER BY total_sales DESC;

--18. What are the monthly sales trends?

SELECT
    TO_CHAR(DATE_TRUNC('month', date), 'YYYY-MM') AS month,
    SUM(sales) AS total_sales
FROM sales
WHERE open = 1
GROUP BY DATE_TRUNC('month', date)
ORDER BY DATE_TRUNC('month', date);

--Section 4 – Promotion Analysis (19–23)

--19. How do promotions affect average sales?

SELECT
    CASE
        WHEN promo = 1 THEN 'Promotion'
        ELSE 'No Promotion'
    END AS promotion_status,
    ROUND(AVG(sales), 2) AS avg_sales
FROM sales
WHERE open = 1
GROUP BY promotion_status

ORDER BY avg_sales DESC;

--20. How do promotions affect customer count?

SELECT
    CASE
        WHEN promo = 1 THEN 'Promotion'
        ELSE 'No Promotion'
    END AS promotion_status,
    ROUND(AVG(customers), 2) AS avg_customers
FROM sales
WHERE open = 1
GROUP BY promotion_status

ORDER BY avg_customers DESC;

--21. Which stores benefit the most from promotions?

WITH store_promo_performance AS (
    SELECT
        store,
        AVG(CASE WHEN promo = 1 THEN sales END) AS promo_avg_sales,
        AVG(CASE WHEN promo = 0 THEN sales END) AS non_promo_avg_sales
    FROM sales
    WHERE open = 1
    GROUP BY store
)

SELECT
    store,
    ROUND(promo_avg_sales, 2) AS promo_avg_sales,
    ROUND(non_promo_avg_sales, 2) AS non_promo_avg_sales,
    ROUND(promo_avg_sales - non_promo_avg_sales, 2) AS sales_uplift
FROM store_promo_performance
WHERE promo_avg_sales IS NOT NULL
  AND non_promo_avg_sales IS NOT NULL
ORDER BY sales_uplift DESC
LIMIT 10;

--22. What is the revenue uplift due to promotions?

SELECT
    ROUND(
        AVG(CASE WHEN promo = 1 THEN sales END)
        -
        AVG(CASE WHEN promo = 0 THEN sales END),
        2
    ) AS revenue_uplift
FROM sales
WHERE open = 1;

--23. Which weekdays perform best during promotions?

SELECT
    dayofweek,
    ROUND(AVG(sales), 2) AS avg_sales
FROM sales
WHERE open = 1
  AND promo = 1
GROUP BY dayofweek
ORDER BY avg_sales DESC;

--Section 5 – Store Analysis (24–28)

--24. Which StoreType generates the highest revenue?

SELECT
    st.storetype,
    SUM(s.sales) AS total_sales
FROM sales s
JOIN stores st
    ON s.store = st.store
WHERE s.open = 1
GROUP BY st.storetype
ORDER BY total_sales DESC;

--25. Which Assortment type performs best?

SELECT
    st.assortment,
    SUM(s.sales) AS total_sales
FROM sales s
JOIN stores st
    ON s.store = st.store
WHERE s.open = 1
GROUP BY st.assortment
ORDER BY total_sales DESC;

--26. Does CompetitionDistance impact sales?

SELECT
    CASE
        WHEN st.competitiondistance < 500
            THEN '<500 m'
        WHEN st.competitiondistance >= 500
             AND st.competitiondistance <= 1000
            THEN '500–1000 m'
        WHEN st.competitiondistance > 1000
             AND st.competitiondistance <= 3000
            THEN '1000–3000 m'
        WHEN st.competitiondistance > 3000
            THEN '>3000 m'
    END AS competition_distance_bucket,

    ROUND(AVG(s.sales), 2) AS avg_daily_sales

FROM sales s
JOIN stores st
    ON s.store = st.store

WHERE s.open = 1
  AND st.competitiondistance IS NOT NULL

GROUP BY competition_distance_bucket


ORDER BY avg_daily_sales DESC;

--27. Which StoreType has the highest average sales?

SELECT
    st.storetype,
    ROUND(AVG(s.sales), 2) AS avg_daily_sales
FROM sales s
JOIN stores st
    ON s.store = st.store
WHERE s.open = 1
GROUP BY st.storetype
ORDER BY avg_daily_sales DESC;

--28. Which Assortment has the highest sales per customer?

SELECT
    st.assortment,
    ROUND(
        SUM(s.sales)::numeric
        / NULLIF(SUM(s.customers), 0),
        2
    ) AS sales_per_customer
FROM sales s
JOIN stores st
    ON s.store = st.store
WHERE s.open = 1
GROUP BY st.assortment
ORDER BY sales_per_customer DESC;

--Section 6 – Advanced SQL (29–35)

--29. Rank all stores by total revenue.

SELECT
    store,
    SUM(sales) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(sales) DESC
    ) AS sales_rank
FROM sales
WHERE open = 1
GROUP BY store
ORDER BY sales_rank;

--30. Find the top 3 stores in each StoreType.

WITH store_sales AS (
    SELECT
        s.store,
        st.storetype,
        SUM(s.sales) AS total_sales
    FROM sales s
    JOIN stores st
        ON s.store = st.store
    WHERE s.open = 1
    GROUP BY
        s.store,
        st.storetype
),

ranked_stores AS (
    SELECT
        store,
        storetype,
        total_sales,
        RANK() OVER (
            PARTITION BY storetype
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM store_sales
)

SELECT
    store,
    storetype,
    total_sales,
    sales_rank
FROM ranked_stores
WHERE sales_rank <= 3
ORDER BY storetype, sales_rank;

--31. Identify stores with consistently increasing sales.

WITH monthly_sales AS (
    SELECT
        store,
        DATE_TRUNC('month', date) AS month,
        SUM(sales) AS total_sales
    FROM sales
    WHERE open = 1
    GROUP BY
        store,
        DATE_TRUNC('month', date)
),

sales_comparison AS (
    SELECT
        store,
        month,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY store
            ORDER BY month
        ) AS previous_month_sales
    FROM monthly_sales
)

SELECT *
FROM sales_comparison
ORDER BY store, month;


