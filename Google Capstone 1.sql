/* 
SCRIPT FOR GOOGLE DATA ANALYTICS CERTIFICATE 2022 - CASE STUDY 1
*/

-- INTEGRATE ALL 12 TABLES INTO 1
INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_0921

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_1021

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_1121

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_1221

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_0122

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_0222

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_0322

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_0422

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_0522

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_0622

INSERT INTO divvy_tripdata_0821
SELECT *
FROM divvy_tripdata_0722

SELECT *
FROM divvy_tripdata_0821

/* DATA CLEANING */
-- Standardize Date Format
SELECT *
FROM divvy_tripdata_0821

ALTER TABLE divvy_tripdata_0821
ADD ride_len time(0);
UPDATE divvy_tripdata_0821
SET ride_len = CONVERT(time(0), ride_length)

SELECT rideable_type, COUNT(rideable_type)
FROM divvy_tripdata_0821
GROUP BY rideable_type
ORDER BY rideable_type

-- CHECK WHETHER THERE'RE ANY SPELLING ERRORS
SELECT TOP (1000) *
FROM divvy_tripdata_0821

SELECT rideable_type, COUNT(rideable_type)
FROM divvy_tripdata_0821
GROUP BY rideable_type
ORDER BY rideable_type

SELECT day_of_week, COUNT(day_of_week)
FROM divvy_tripdata_0821
GROUP BY day_of_week
ORDER BY day_of_week

-- DELETE INCORRECT "ride_length" VALUES
SELECT TOP (1000) *
FROM divvy_tripdata_0821
WHERE started_at > ended_at

DELETE
FROM divvy_tripdata_0821
WHERE ride_length IS NULL

-- REMOVE UNUSED COLUMNS
SELECT TOP (1000) *
FROM divvy_tripdata_0821

ALTER TABLE divvy_tripdata_0821
DROP COLUMN ride_length

-- Seperate datetime ("started_at", "ended_at") to smaller columns
SELECT TOP (1000) *
FROM divvy_tripdata_0821
ORDER BY Year DESC

ALTER TABLE divvy_tripdata_0821
DROP COLUMN MonthYear

ALTER TABLE divvy_tripdata_0821 ADD
Year INT
UPDATE divvy_tripdata_0821
SET Year = CAST(DATEPART(YEAR, started_at) AS INT)

ALTER TABLE divvy_tripdata_0821 ADD
Month INT;
UPDATE divvy_tripdata_0821
SET Month = CAST(DATEPART(MONTH, started_at) AS INT)

ALTER TABLE divvy_tripdata_0821 ADD
StartHour INT
UPDATE divvy_tripdata_0821
SET StartHour = CAST(DATEPART(HOUR, started_at) AS INT)

ALTER TABLE divvy_tripdata_0821 ADD
MonthYear nvarchar(255)
UPDATE divvy_tripdata_0821
SET MonthYear = CONCAT(Month,'-',Year)

-- ADD Name of weekday column

SELECT TOP (1000) *
FROM divvy_tripdata_0821

ALTER TABLE divvy_tripdata_0821 ADD
weekday nvarchar(255)

UPDATE divvy_tripdata_0821
SET weekday =
(CASE WHEN day_of_week = 1 THEN 'Sunday'
			WHEN day_of_week = 2 THEN 'Monday'
			WHEN day_of_week = 3 THEN 'Tuesday'
			WHEN day_of_week = 4 THEN 'Wednesday'
			WHEN day_of_week = 5 THEN 'Thursday'
			WHEN day_of_week = 6 THEN 'Friday'
			ELSE 'Saturday' END)

-- ADD start_date column
ALTER TABLE divvy_tripdata_0821 ADD
start_date date

UPDATE divvy_tripdata_0821
SET start_date = CONVERT(date, started_at)

/*
How do annual members and casual riders use Cyclistic bikes differently?
*/

SELECT TOP (1000) *
FROM divvy_tripdata_0821

-- Looking at the total number of rows.
SELECT COUNT(*) AS num_of_rows
FROM divvy_tripdata_0821

SELECT rideable_type, COUNT(rideable_type) AS num_of_rideable_type
FROM divvy_tripdata_0821
GROUP BY rideable_type

SELECT member_casual, 
	   COUNT(member_casual) AS num_of_member_casual,
	   SUM(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS total_length_per_type,
	   AVG(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS avg_length_per_type
FROM divvy_tripdata_0821
GROUP BY member_casual

SELECT member_casual, SUM(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS num_of_ridelen_per_type
FROM divvy_tripdata_0821
GROUP BY member_casual

-- Looking at the distinct values
SELECT	DISTINCT rideable_type
FROM divvy_tripdata_0821

SELECT DISTINCT member_casual
FROM divvy_tripdata_0821

SELECT DISTINCT day_of_week
FROM divvy_tripdata_0821

SELECT COUNT(DISTINCT ride_id) AS distinct_ride_id, COUNT(*) AS num_of_rows, (COUNT(*)-COUNT(DISTINCT ride_id)) AS differ
FROM divvy_tripdata_0821

-- Looking at the maximum, minimum, or mean values.
SELECT TOP (1000) *
FROM divvy_tripdata_0821
WHERE ride_len = '00:00:00'

SELECT rideable_type
	  ,MAX(ride_len) AS max_of_ride_len
	  ,MIN(ride_len) AS min_of_ride_len
FROM divvy_tripdata_0821
GROUP BY rideable_type
ORDER BY 2 DESC,3 DESC

SELECT member_casual
	  ,MAX(ride_len) AS max_of_ride_len
	  ,MIN(ride_len) AS min_of_ride_len
FROM divvy_tripdata_0821
GROUP BY member_casual
ORDER BY 2 DESC,3 DESC

SELECT rideable_type, member_casual
	  ,MAX(ride_len) AS max_of_ride_len
	  ,MIN(ride_len) AS min_of_ride_len
FROM divvy_tripdata_0821
GROUP BY rideable_type, member_casual
ORDER BY 1 DESC, 2 DESC

-- Looking at mean values.
-- Find means of "ride_len" seperated by types of riders
SELECT rideable_type, member_casual
	  ,AVG(CAST(DATEDIFF(SECOND, '00:00:00', ride_len) AS bigint)) max_of_ride_len
FROM divvy_tripdata_0821
GROUP BY rideable_type, member_casual
ORDER BY 1 DESC, 2 DESC

SELECT rideable_type
	  ,AVG(CAST(DATEDIFF(SECOND, '00:00:00', ride_len) AS bigint)) max_of_ride_len
FROM divvy_tripdata_0821
GROUP BY rideable_type
ORDER BY 1 DESC, 2 DESC

SELECT member_casual
	  ,AVG(CAST(DATEDIFF(SECOND, '00:00:00', ride_len) AS bigint)) max_of_ride_len
FROM divvy_tripdata_0821
GROUP BY member_casual
ORDER BY 1 DESC, 2 DESC

-- SUM UP
CREATE VIEW Sum_up_by_member_type AS
SELECT member_casual, 
	   COUNT(member_casual) AS num_of_member_casual,
	   SUM(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS total_length_per_type,
	   AVG(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS avg_length_per_type
FROM divvy_tripdata_0821
GROUP BY member_casual

/* CREATE VIZ IN TABLEAU */
-- VIZ 1
SELECT member_casual, 
	   COUNT(member_casual) AS num_of_member_casual,
	   SUM(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS total_length_per_type,
	   AVG(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS avg_length_per_type
FROM divvy_tripdata_0821
GROUP BY member_casual

-- VIZ 2: Member by StartHour
SELECT  StartHour, member_casual, COUNT(member_casual) AS num_of_member,
		SUM(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS total_length_per_type,
		AVG(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS avg_length_per_type
FROM divvy_tripdata_0821
GROUP BY  StartHour, member_casual
ORDER BY 1,2

-- VIZ 3: Member by Month
SELECT  MonthYear, member_casual, COUNT(member_casual) AS num_of_member,
		SUM(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS total_length_per_type,
		AVG(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS avg_length_per_type
FROM divvy_tripdata_0821
GROUP BY  MonthYear, member_casual
ORDER BY 1,2

-- VIZ 4: Member by day_of_week
SELECT  weekday, member_casual, COUNT(member_casual) AS num_of_member, 
	    SUM(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS total_length_per_type,
		AVG(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS avg_length_per_type
FROM divvy_tripdata_0821
GROUP BY weekday, member_casual 
ORDER BY 1,2

-- VIZ 5: Member by date
SELECT  start_date, member_casual, COUNT(member_casual) AS num_of_member, 
	    SUM(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS total_length_per_type,
		AVG(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS avg_length_per_type
FROM divvy_tripdata_0821
GROUP BY start_date, member_casual 
ORDER BY 1,2

SELECT TOP (1000) * 
FROM divvy_tripdata_0821

-- Member week per hour
SELECT  weekday, StartHour, member_casual, COUNT(member_casual) AS num_of_member,
		SUM(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS total_length_per_type,
		AVG(CAST(DATEDIFF(SECOND,'00:00:00', ride_len) AS bigint)) AS avg_length_per_type
FROM divvy_tripdata_0821
GROUP BY  weekday, StartHour, member_casual
ORDER BY 1,2,3

-- Rideable_type per member_casual
SELECT member_casual, rideable_type, COUNT(rideable_type) AS rider_per_member
FROM divvy_tripdata_0821
GROUP BY member_casual, rideable_type
ORDER BY 1,2

