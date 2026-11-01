
-- ============================================
-- UK Railway Data Warehouse
-- Gold Layer - Star Schema & Analytical Views
-- ============================================

USE UK_Railway_DWH;
GO

-- ============================================
-- 1. Tickets Dimension
-- ============================================

CREATE VIEW gold.dim_tickets AS
SELECT
    t.Ticket_ID,
    t.Ticket_Class,
    t.Ticket_Type
FROM silver.tickets t;
GO

-- ============================================
-- 2. Railcards Dimension
-- ============================================

CREATE VIEW gold.dim_railcards AS
SELECT
    r.Railcard_ID,
    r.Railcard_Name
FROM silver.railcards r;
GO

-- ============================================
-- 3. Departure Stations Dimension
-- ============================================

CREATE VIEW gold.dim_departure_stations AS
SELECT
    Station_ID,
    Station_Name AS Departure_Station_Name
FROM silver.stations;
GO

-- ============================================
-- 4. Arrival Stations Dimension
-- ============================================

CREATE VIEW gold.dim_arrival_stations AS
SELECT
    Station_ID,
    Station_Name AS Arrival_Station_Name
FROM silver.stations;
GO

-- ============================================
-- 5. Sales Fact View
-- ============================================

CREATE VIEW gold.fact_sales AS
SELECT
    s.Transaction_ID,
    s.Ticket_ID,
    s.Railcard_ID,
    s.Purchase_Date,
    s.Purchase_Time,
    s.Price_GBP,
    s.Purchase_Channel,
    s.Payment_Method,
    j.Journey_ID,
    j.Journey_Date,
    j.Departure_Station_ID,
    j.Arrival_Station_ID,
    j.Scheduled_Departure_Time,
    j.Scheduled_Arrival_Time,
    j.Actual_Arrival_Time,
    j.Journey_Status,
    j.Delay_Reason,

    ISNULL(r.Refund_Requested, 'NO') AS Refund_Requested,

    CASE
        WHEN d.Station_ID IS NOT NULL
         AND a.Station_ID IS NOT NULL
        THEN CONCAT(
            d.Departure_Station_Name,
            ' - ',
            a.Arrival_Station_Name
        )
        ELSE NULL
    END AS Route

FROM silver.sales s

LEFT JOIN silver.journeys j
    ON s.Transaction_ID = j.Transaction_ID

LEFT JOIN silver.refunds r
    ON s.Transaction_ID = r.Transaction_ID

LEFT JOIN gold.dim_departure_stations d
    ON j.Departure_Station_ID = d.Station_ID

LEFT JOIN gold.dim_arrival_stations a
    ON j.Arrival_Station_ID = a.Station_ID

WHERE s.Purchase_Date >= '2024-01-01'
   OR s.Purchase_Date IS NULL;
GO

-- ============================================
-- 6. Date Dimension
-- ============================================

CREATE VIEW gold.dim_date AS
WITH date_range AS (
    SELECT
        MIN(Full_Date) AS Min_Date,
        MAX(Full_Date) AS Max_Date
    FROM (
        SELECT Purchase_Date AS Full_Date
        FROM gold.fact_sales

        UNION ALL

        SELECT Journey_Date
        FROM gold.fact_sales
    ) d
),

dates AS (
    SELECT
        DATEADD(DAY, g.value, r.Min_Date) AS Full_Date
    FROM date_range r
    CROSS APPLY GENERATE_SERIES(
        0,
        DATEDIFF(DAY, r.Min_Date, r.Max_Date)
    ) g
)

SELECT
    Full_Date,
    YEAR(Full_Date) AS Year,
    DATEPART(QUARTER, Full_Date) AS Quarter,
    MONTH(Full_Date) AS Month_Number,
    DATENAME(MONTH, Full_Date) AS Month_Name,
    CONCAT(
        YEAR(Full_Date),
        '-',
        RIGHT('0' + CAST(MONTH(Full_Date) AS VARCHAR(2)), 2)
    ) AS Year_Month
FROM dates;
GO

-- ============================================
-- 7. Purchase Date Dimension
-- ============================================

CREATE VIEW gold.dim_purchase_date AS
SELECT
    Full_Date,
    Year,
    Quarter,
    Month_Number,
    Month_Name,
    Year_Month
FROM gold.dim_date;
GO

-- ============================================
-- 8. Journey Date Dimension
-- ============================================

CREATE VIEW gold.dim_journey_date AS
SELECT
    Full_Date,
    Year,
    Quarter,
    Month_Number,
    Month_Name,
    Year_Month
FROM gold.dim_date;
GO
