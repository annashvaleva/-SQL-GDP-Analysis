/* ============================================================
   QUESTION 6 — Running Total by Continent (2009)
   ============================================================
   Objective:
   - List all 2009 per_capita records with:
       continent_name, country_code, country_name, gdp_per_capita
   - Sort by:
       1. continent_name (ASC)
       2. characters 2–4 of country_name (DESC)
   - Compute a running total (cumulative sum) of gdp_per_capita 
     per continent.
   - Return only the first record per continent 
     where running_total ≥ $70,000.00.
=============================================================== */

WITH ranked AS (
    SELECT 
        c.continent_name,
        cn.country_code,
        cn.country_name,
        pc.gdp_per_capita,
        --- Running total per continent
        SUM(pc.gdp_per_capita) OVER (
            PARTITION BY c.continent_name
            ORDER BY SUBSTRING(cn.country_name, 2, 3) DESC
            ROWS UNBOUNDED PRECEDING
        ) AS running_total
    FROM per_capita pc
    JOIN continent_map cm ON pc.country_code = cm.country_code
    JOIN continents c ON cm.continent_code = c.continent_code
    JOIN countries cn ON cm.country_code = cn.country_code
    WHERE pc.year = 2009
)
SELECT 
    continent_name,
    country_code,
    country_name,
    CONCAT('$', FORMAT(ROUND(gdp_per_capita, 2), 'N2')) AS gdp_per_capita,
    CONCAT('$', FORMAT(ROUND(running_total, 2), 'N2')) AS running_total
FROM ranked
WHERE running_total >= 70000
  AND running_total = (
      SELECT MIN(r2.running_total)
      FROM ranked r2
      WHERE r2.continent_name = ranked.continent_name
        AND r2.running_total >= 70000
  )
ORDER BY continent_name;

/*
---------------------------------------------------------------
RESULT:
---------------------------------------------------------------
continent_name | country_code | country_name | gdp_per_capita | running_total
------------------------------------------------------------------------------
Africa         | LBY          | Libya        | $10,455.57     | $70,227.16
Asia           | KWT          | Kuwait       | $37,160.54     | $73,591.81
Europe         | CHE          | Switzerland  | $65,790.07     | $84,673.58
North America  | ABW          | Aruba        | $24,639.94     | $84,504.67
Oceania        | NZL          | New Zealand  | $27,474.33     | $84,623.91
South America  | ECU          | Ecuador      | $4,236.78      | $72,315.82
---------------------------------------------------------------
Explanation:
- The window function SUM(...) OVER(...) calculates a cumulative
  running total of GDP per capita within each continent.
- Countries are ordered by substring(country_name, 2–4) in descending order.
- Only the first record per continent with a running total ≥ $70,000 
  is displayed.
---------------------------------------------------------------
*/