
-- ============================================
-- UK Railway Data Warehouse
-- Silver Layer - Data Cleaning & Transformation
-- ============================================

USE UK_Railway_DWH;
GO

-- ============================================
-- 1. Journeys
-- ============================================

CREATE VIEW silver.journeys AS
SELECT DISTINCT
    TRIM(j.Journey_ID) AS Journey_ID,
    TRIM(j.Transaction_ID) AS Transaction_ID,
    j.Departure_Station_ID,
    j.Arrival_Station_ID,
    TRY_CAST(j.Journey_Date AS DATE) AS Journey_Date,
    TRY_CAST(j.Scheduled_Departure_Time AS TIME) AS Scheduled_Departure_Time,
    TRY_CAST(j.Scheduled_Arrival_Time AS TIME) AS Scheduled_Arrival_Time,
    TRY_CAST(j.Actual_Arrival_Time AS TIME) AS Actual_Arrival_Time,
    UPPER(TRIM(j.Journey_Status)) AS Journey_Status,
    CASE
        WHEN LOWER(TRIM(j.Delay_Reason)) = 'unknown'
            THEN 'Unknown'
        WHEN LOWER(TRIM(j.Delay_Reason)) IN ('weather', 'weather conditions')
            THEN 'Weather Conditions'
        WHEN LOWER(TRIM(j.Delay_Reason)) IN ('staff shortage', 'staffing')
            THEN 'Staffing'
        ELSE TRIM(j.Delay_Reason)
    END AS Delay_Reason
FROM bronze.journeys j
WHERE NULLIF(TRIM(j.Journey_ID), '') IS NOT NULL
  AND NULLIF(TRIM(j.Transaction_ID), '') IS NOT NULL;
GO

-- ============================================
-- 2. Railcards
-- ============================================

CREATE VIEW silver.railcards AS
SELECT
    TRIM(r.Railcard_ID) AS Railcard_ID,
    TRIM(UPPER(r.Railcard_Name)) AS Railcard_Name
FROM bronze.railcards r;
GO

-- ============================================
-- 3. Refunds
-- ============================================

CREATE VIEW silver.refunds AS
SELECT DISTINCT
    TRIM(r.Refund_ID) AS Refund_ID,
    TRIM(r.Transaction_ID) AS Transaction_ID,
    UPPER(TRIM(r.Refund_Requested)) AS Refund_Requested
FROM bronze.refunds r;
GO

-- ============================================
-- 4. Sales
-- ============================================

CREATE VIEW silver.sales AS
SELECT DISTINCT
    TRIM(s.Transaction_ID) AS Transaction_ID,
    TRY_CAST(s.Purchase_Date AS DATE) AS Purchase_Date,
    TRY_CAST(s.Purchase_Time AS TIME) AS Purchase_Time,
    TRIM(s.Purchase_Channel) AS Purchase_Channel,
    TRIM(REPLACE(UPPER(Payment_Method), ' ', '_')) AS Payment_Method,
    TRIM(s.Ticket_ID) AS Ticket_ID,
    TRIM(s.Railcard_ID) AS Railcard_ID,
    CASE
        WHEN TRY_CAST(TRIM(s.Price_GBP) AS DECIMAL(10,2)) < 0
            THEN NULL
        ELSE TRY_CAST(TRIM(s.Price_GBP) AS DECIMAL(10,2))
    END AS Price_GBP
FROM bronze.sales s
WHERE NULLIF(TRIM(s.Transaction_ID), '') IS NOT NULL;
GO

-- ============================================
-- 5. Stations
-- ============================================

CREATE VIEW silver.stations AS
SELECT DISTINCT
    TRIM(s.Station_ID) AS Station_ID,
    UPPER(TRIM(s.Station_Name)) AS Station_Name
FROM bronze.stations s;
GO

-- ============================================
-- 6. Tickets
-- ============================================

CREATE VIEW silver.tickets AS
SELECT DISTINCT
    TRIM(t.Ticket_ID) AS Ticket_ID,
    UPPER(TRIM(t.Ticket_Class)) AS Ticket_Class,
    UPPER(TRIM(t.Ticket_Type)) AS Ticket_Type
FROM bronze.tickets t;
GO
