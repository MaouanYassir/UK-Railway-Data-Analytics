
-- ============================================
-- UK Railway Data Warehouse
-- Bronze Layer - Raw Data Tables
-- ============================================

USE UK_Railway_DWH;
GO

-- ============================================
-- 1. Journeys
-- ============================================

CREATE TABLE bronze.journeys (
    Journey_ID NVARCHAR(50) NULL,
    Transaction_ID NVARCHAR(50) NULL,
    Departure_Station_ID NVARCHAR(50) NULL,
    Arrival_Station_ID NVARCHAR(50) NULL,
    Journey_Date NVARCHAR(50) NULL,
    Scheduled_Departure_Time NVARCHAR(50) NULL,
    Scheduled_Arrival_Time NVARCHAR(50) NULL,
    Actual_Arrival_Time NVARCHAR(50) NULL,
    Journey_Status NVARCHAR(50) NULL,
    Delay_Reason NVARCHAR(50) NULL
);

-- ============================================
-- 2. Railcards
-- ============================================

CREATE TABLE bronze.railcards (
    Railcard_ID NVARCHAR(50) NULL,
    Railcard_Name NVARCHAR(50) NULL
);

-- ============================================
-- 3. Refunds
-- ============================================

CREATE TABLE bronze.refunds (
    Refund_ID NVARCHAR(50) NULL,
    Transaction_ID NVARCHAR(50) NULL,
    Refund_Requested NVARCHAR(50) NULL
);

-- ============================================
-- 4. Sales
-- ============================================

CREATE TABLE bronze.sales (
    Transaction_ID NVARCHAR(50) NULL,
    Purchase_Date NVARCHAR(50) NULL,
    Purchase_Time NVARCHAR(50) NULL,
    Purchase_Channel NVARCHAR(50) NULL,
    Payment_Method NVARCHAR(50) NULL,
    Ticket_ID NVARCHAR(50) NULL,
    Railcard_ID NVARCHAR(50) NULL,
    Price_GBP NVARCHAR(50) NULL
);

-- ============================================
-- 5. Stations
-- ============================================

CREATE TABLE bronze.stations (
    Station_ID NVARCHAR(50) NULL,
    Station_Name NVARCHAR(50) NULL
);

-- ============================================
-- 6. Tickets
-- ============================================

CREATE TABLE bronze.tickets (
    Ticket_ID NVARCHAR(50) NULL,
    Ticket_Class NVARCHAR(50) NULL,
    Ticket_Type NVARCHAR(50) NULL
);
