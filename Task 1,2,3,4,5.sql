--task1
--Q1)Convert the time column into DATE and TIME fields using SQL date/time functions.
ALTER TABLE earthquakes
ADD COLUMN date_only DATE,
ADD COLUMN time_only TIME;
UPDATE earthquakes
SET 
    date_only = time::DATE,
    time_only = time::TIME;

select * from earthquakes;

--Q2)Remove rows with null or missing values in critical columns: mag, latitude, longitude, depth.
DELETE FROM earthquakes
WHERE mag IS NULL
   OR latitude IS NULL
   OR longitude IS NULL
   OR depth IS NULL;

select * from earthquakes;

--Q3)Standardize the place field: remove extra spaces and ensure consistent capitalization.
UPDATE earthquakes
SET place = INITCAP(REGEXP_REPLACE(TRIM(place), '\s+', ' ', 'g'));

-- Force direction words to uppercase
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bNnw\b', 'NNW', 'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bNne\b', 'NNE', 'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bEne\b', 'ENE', 'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bEse\b', 'ESE', 'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bSse\b', 'SSE', 'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bSsw\b', 'SSW', 'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bWsw\b', 'WSW', 'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bWnw\b', 'WNW', 'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bNw\b',  'NW',  'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bNe\b',  'NE',  'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bSe\b',  'SE',  'g');
UPDATE earthquakes SET place = REGEXP_REPLACE(place, '\bSw\b',  'SW',  'g');

select place from earthquakes;

--Q4)Validate numeric data types for mag, depth, latitude, and longitude.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'earthquakes'
  AND column_name IN ('mag', 'depth', 'latitude', 'longitude');


--task2
--Q1)Count the total number of earthquakes in the dataset.
SELECT COUNT(*) AS total_earthquakes
FROM earthquakes;

--Q2)Find the Top 10 locations (using place) with the highest number of recorded events.
SELECT 
    place, 
    COUNT(*) AS event_count
FROM 
    earthquakes
GROUP BY 
    place
ORDER BY 
    event_count DESC
LIMIT 10;

--Q3)Count earthquakes by magnitude range. Minor (< 4.0), Light (4.0–5.9), Moderate (6.0–6.9), 
--Strong (7.0–7.9) and Major (8.0+).
SELECT
  CASE
    WHEN mag < 4.0 THEN 'Minor (<4.0)'
    WHEN mag >= 4.0 AND mag < 6.0 THEN 'Light (4.0–5.9)'
    WHEN mag >= 6.0 AND mag < 7.0 THEN 'Moderate (6.0–6.9)'
    WHEN mag >= 7.0 AND mag < 8.0 THEN 'Strong (7.0–7.9)'
    WHEN mag >= 8.0 THEN 'Major (8.0+)'
    ELSE 'Unknown'
  END AS magnitude_range,
  COUNT(*) AS total
FROM earthquakes
GROUP BY magnitude_range
ORDER BY total DESC;

--Q4)Average magnitude by year.
SELECT
  EXTRACT(YEAR FROM date_only) AS year,
  ROUND(AVG(mag), 2) AS average_magnitude
FROM earthquakes
WHERE mag IS NOT NULL
GROUP BY year
ORDER BY year;


--task 3
--Q1)Count the number of earthquakes by month and year.
SELECT
  EXTRACT(YEAR FROM date_only) AS year,
  EXTRACT(MONTH FROM date_only) AS month,
  COUNT(*) AS total_earthquakes
FROM earthquakes
GROUP BY year, month
ORDER BY year, month;

--Q2)Identify months with the highest number of significant earthquakes.
SELECT
  TO_CHAR(date_only, 'Month') AS month,
  COUNT(*) AS significant_earthquakes
FROM earthquakes
WHERE mag >= 6.0
GROUP BY month
ORDER BY significant_earthquakes DESC;

--Q3)Trend: Number of earthquakes per year over time.
SELECT 
  EXTRACT(YEAR FROM date_only) AS year,
  COUNT(*) AS total_earthquakes
FROM earthquakes
GROUP BY year
ORDER BY year;

--task 4
--Q1)Average depth of earthquakes grouped by region or partial text from place.
SELECT
  CASE 
    WHEN place ILIKE '%,%' THEN TRIM(SPLIT_PART(place, ',', 2))
    ELSE place
  END AS region,
  ROUND(AVG(depth), 2) AS average_depth
FROM earthquakes
GROUP BY region
ORDER BY average_depth DESC;

--Q2)Count of earthquakes by depth category. Shallow (< 70 km), Intermediate (70–300 km) 
--and Deep (> 300 km).
SELECT
  CASE
    WHEN depth < 70 THEN 'Shallow (<70 km)'
    WHEN depth >= 70 AND depth <= 300 THEN 'Intermediate (70–300 km)'
    WHEN depth > 300 THEN 'Deep (>300 km)'
    ELSE 'Unknown'
  END AS depth_category,
  COUNT(*) AS total
FROM earthquakes
GROUP BY depth_category
ORDER BY total DESC;

--Q3)Top 5 deepest earthquakes with their place, mag, and depth.
SELECT place, mag, depth
FROM earthquakes
ORDER BY depth DESC
LIMIT 5;

--task 5
--Q1)Window Function: Rank earthquakes by magnitude within each year.
SELECT
  date_only,
  place,
  mag,
  RANK() OVER (
    PARTITION BY EXTRACT(YEAR FROM date_only)
    ORDER BY mag DESC
  ) AS rank_within_year
FROM earthquakes;

--Q2)Running Total: Create a query showing cumulative count of earthquakes over time.
SELECT
  date_only,
  COUNT(*) OVER (
    ORDER BY date_only
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_earthquakes
FROM earthquakes
ORDER BY date_only;

--Q3)Boolean Flag: Add a column for “High Risk” earthquakes where mag > 7.0 AND depth < 70 km.
SELECT
  *,
  CASE
    WHEN mag > 7.0 AND depth < 70 THEN TRUE
    ELSE FALSE
  END AS high_risk
FROM earthquakes;

--Q4)Find earthquakes with unusually large azimuthal gaps (gap > 180°).
SELECT 
    id,
    time,
    place,
    mag,
    depth,
    gap
FROM 
    earthquakes
WHERE 
    gap > 180;


