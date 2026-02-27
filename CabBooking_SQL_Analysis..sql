-- Database create
create database cab_bookings
use cab_bookings
-- Table form as cab_booking


select * from cab_booking;

ALTER TABLE cab_booking
ALTER COLUMN Time TIME(0);
-- Total Bookings in july

Select count(Booking_ID) as total_booking from cab_booking;

-- Revenue Analysis

-- 1. Howmuch revenue generated in july ?

SELECT
	SUM(Booking_Value) AS Total_Revenue
FROM cab_booking
WHERE Ride_Status = 'Completed';

-- 2. How much revenue is lost due to cancelled rides?

SELECT
	SUM(Booking_Value) AS Revenue_Lost
FROM cab_booking
WHERE Ride_Status = 'Cancelled';

-- Customer Cancellation Behaviour

-- 1.What is the overall Ride Completion Rate?

SELECT
   COUNT(CASE WHEN Ride_Status='Completed' THEN 1 END)*100
   /COUNT(*) AS Ride_Completion_Rate
FROM Cab_booking;

-- 2. What is the Ride Cancellation Rate?

SELECT 
	COUNT(CASE WHEN Ride_Status='Cancelled' THEN 1 END)*100
	/COUNT(*) AS Cancellation_Rate
FROM cab_booking;

-- 3.Which vehicle type has highest Completion rate?

SELECT Vehicle_Type,
COUNT(CASE WHEN Ride_Status='Completed' THEN 1 END)*100.0
/COUNT(*) AS Completion_Rate
FROM cab_booking
GROUP BY Vehicle_Type
ORDER BY Completion_Rate DESC;

-- 4.Which vehicle type has highest Cancellation rate?

SELECT Vehicle_Type,
COUNT(CASE WHEN Ride_Status='Cancelled' THEN 1 END)*100.0
/COUNT(*) AS Cancellation_Rate
FROM cab_booking
GROUP BY Vehicle_Type
ORDER BY Cancellation_Rate;


-- Revenue Collection rate per vehical

-- 1.Does one vehicle type dominate revenue?

SELECT 
   Vehicle_Type,
   SUM(Revenue) 
   AS Revenue_Percentage
FROM cab_booking
GROUP BY Vehicle_Type
ORDER BY Revenue_Percentage DESC;

-- 2.Is revenue higher on weekends?

SELECT Weekend_Weekday,
SUM(Revenue) AS Total_Revenue
FROM cab_booking
GROUP BY Weekend_Weekday;

-- Payment Mode Behavior

-- which payment mode generate more completed rides ?

SELECT 
	Payment_Method,
	COUNT(CASE WHEN Ride_Status='Completed' THEN 1 END) 
	AS Completed_Rides
FROM cab_booking
GROUP BY Payment_Method
ORDER BY Completed_Rides DESC;

-- Most Profitable Distance Segment

SELECT 
	Distance_category,
	SUM(Revenue) AS Total_Revenue
FROM cab_booking
GROUP BY Distance_category
ORDER BY Total_Revenue DESC;



-- Demand Time Analysis

-- At what hour is ride demand highest?
SELECT 
    DATEPART(HOUR, Time) AS Ride_Hour,
    COUNT(*) AS Total_Bookings
FROM cab_booking
GROUP BY DATEPART(HOUR, Time)
ORDER BY Total_Bookings DESC;

-- Distance vs Cancellation
-- Do long rides get cancelled more?

SELECT
	Distance_category,
	COUNT(CASE WHEN Ride_Status='Cancelled' THEN 1 END)*100
	/COUNT(*) AS Cancel_Risk
FROM cab_booking
GROUP BY Distance_category
ORDER BY Cancel_Risk DESC;

-- Customer Satisfaction 

-- Which vehicle has lowest customer rating?

SELECT
	Vehicle_Type,
	MIN(Customer_Rating) AS Min_Rating
FROM cab_booking
GROUP BY Vehicle_Type;

-- Which vehicle has maximum customer rating?

SELECT
	Vehicle_Type,
	MAX(Customer_Rating) AS Min_Rating
FROM cab_booking
GROUP BY Vehicle_Type;

-- Cancellation Probability by Hour

SELECT 
	DATEPART(HOUR, Time) AS Ride_Hour,
	COUNT(CASE WHEN Ride_Status='Cancelled' THEN 1 END)*100.0
	/COUNT(*) AS Cancel_Probability
FROM cab_booking
GROUP BY DATEPART(HOUR, Time)
ORDER BY Cancel_Probability DESC;

-- KPI VIEW for power bi

CREATE VIEW KPI_Dashboard AS
SELECT
COUNT(*) AS Total_Bookings,
SUM(Revenue) AS Total_Revenue,
AVG(Ride_Distance) AS Avg_Ride_Distance,
AVG(Customer_Rating) AS Avg_Customer_Rating,
COUNT(CASE WHEN Ride_Status='Cancelled' THEN 1 END)*100.0
/COUNT(*) AS Cancellation_Percentage
FROM cab_booking;

SELECT * FROM KPI_Dashboard;

