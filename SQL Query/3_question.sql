/*
===========================================================
Question 3 – GDP Share by Region (2012)
===========================================================
Task:
For the year 2012, create a report with three columns (Asia, Europe, Rest of World)
showing the percentage share of GDP per capita for each region.
-----------------------------------------------------------
Expected Output Format:
 Asia     | Europe   | Rest of World
----------|----------|---------------
 25.0%    | 25.0%    | 50.0%
===========================================================
*/

SELECT 
    CONCAT(FORMAT(ROUND(
        (SUM(CASE WHEN c.continent_name = 'Asia' THEN pc.gdp_per_capita ELSE 0 END) 
        / SUM(pc.gdp_per_capita) * 100), 2), 'N2'), '%') AS Asia,
        
    CONCAT(FORMAT(ROUND(
        (SUM(CASE WHEN c.continent_name = 'Europe' THEN pc.gdp_per_capita ELSE 0 END)
        / SUM(pc.gdp_per_capita) * 100), 2), 'N2'), '%') AS Europe,
        
    CONCAT(FORMAT(ROUND(
        (SUM(CASE WHEN c.continent_name NOT IN ('Asia', 'Europe') THEN pc.gdp_per_capita ELSE 0 END)
        / SUM(pc.gdp_per_capita) * 100), 2), 'N2'), '%') AS [Rest of World]
FROM dbo.per_capita pc
JOIN dbo.continent_map cm ON pc.country_code = cm.country_code
JOIN dbo.continents c ON cm.continent_code = c.continent_code
WHERE pc.year = 2012;

/*
-----------------------------------------------------------
Explanation:
-----------------------------------------------------------

1. Data Source:
- per_capita: GDP per capita data by country and year
- continent_map: connects countries to their continent
- continents: contains continent names

-----------------------------------------------------------
2. Logic:
- SUM with CASE WHEN counts only the desired continents.
- Each CASE gives the total GDP for a region.
- Dividing by the world total gives the percentage share.

Formula:
    (SUM(region_GDP) / SUM(global_GDP)) * 100

-----------------------------------------------------------
3. Formatting:
- ROUND(..., 2): rounds to 2 decimal places
- FORMAT(..., 'N2'): ensures 2-digit precision
- CONCAT(..., '%'): adds a percentage symbol

-----------------------------------------------------------
4. "Rest of World":
- Includes all continents except Asia and Europe
-----------------------------------------------------------

 Final Output (Your Result):
 Asia   | Europe | Rest of World
--------|--------|---------------
 28.33% | 42.24% | 29.43%

-----------------------------------------------------------
Comment:
This query demonstrates conditional aggregation and formatted
output in SQL. It shows how to calculate percentage distributions
for defined groups using SUM and CASE expressions.
-----------------------------------------------------------
*/