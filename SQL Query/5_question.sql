/*
   ===========================================================
   QUESTION 5 — GDP per Capita by Year for Countries Missing 2012 Data
   ============================================================
   Objective:
   Find the total GDP per capita and the number of countries 
   for each year (before 2012) where:
   - GDP per capita is NOT NULL;
   - The country has a NULL GDP per capita in 2012.
=============================================================== */

SELECT 
    pc.year,
    COUNT(DISTINCT pc.country_code) AS country_count,
    CONCAT('$', FORMAT(ROUND(SUM(pc.gdp_per_capita), 2), 'N2')) AS total
FROM per_capita pc
WHERE pc.gdp_per_capita IS NOT NULL
  AND pc.year < 2012
  AND pc.country_code IN (
        SELECT country_code
        FROM per_capita
        WHERE year = 2012 AND gdp_per_capita IS NULL
    )
GROUP BY pc.year
ORDER BY pc.year;

/*
---------------------------------------------------------------
RESULT:
---------------------------------------------------------------
year | country_count | total
----------------------------------------
2004 | 15 | $491,203.19
2005 | 15 | $510,734.98
2006 | 14 | $553,689.65
2007 | 14 | $654,508.77
2008 | 10 | $574,016.21
2009 |  9 | $473,103.34
2010 |  4 | $179,750.83
2011 |  4 | $199,152.68
---------------------------------------------------------------
Explanation:
- First, we find all countries with NULL GDP per capita in 2012.
- Then, we take their data for years before 2012 (only where GDP is NOT NULL).
- For each year, we count unique countries and sum their GDP per capita.
---------------------------------------------------------------
*/
