# Global-Earthquake-Analysis-Using-SQL
Analyzed the Global Earthquake Catalog using SQL to uncover seismic trends by time, magnitude, and depth, applying advanced SQL functions to build comprehensive insights into earthquake frequency, risk, and geographic patterns.

Task 1:
Data Cleaning And Preprocessing:
1.Convert the time column into DATE and TIME fields using SQL date/time functions.
2.Remove rows with null or missing values in critical columns: mag, latitude, longitude, depth.
3.Standardize the place field: remove extra spaces and ensure consistent capitalization.
4.Validate numeric data types for mag, depth, latitude, and longitude.

Task 2:
Earthquake Frequency And Magnitude Analysis:
1.Count the total number of earthquakes in the dataset.
2.Find the Top 10 locations (using place) with the highest number of recorded events.
3.Count earthquakes by magnitude range. Minor (< 4.0), Light (4.0–5.9), Moderate (6.0–6.9), Strong (7.0–7.9) and Major (8.0+).
4.Average magnitude by year.

Task 3:
Temporal Analysis:
1.Count the number of earthquakes by month and year.
2.Identify months with the highest number of significant earthquakes.
3.Trend: Number of earthquakes per year over time.

Task 4:
Geographic And Depth Analysis:
1.Average depth of earthquakes grouped by region or partial text from place.
2.Count of earthquakes by depth category. Shallow (< 70 km), Intermediate (70–300 km) and Deep (> 300 km).
3.Top 5 deepest earthquakes with their place, mag, and depth.

Task 5:
Advanced SQL Queries:
1.Window Function: Rank earthquakes by magnitude within each year.
2.Running Total: Create a query showing cumulative count of earthquakes over time.
3.Boolean Flag: Add a column for “High Risk” earthquakes where mag > 7.0 AND depth < 70 km.
4.Find earthquakes with unusually large azimuthal gaps (gap > 180°).

