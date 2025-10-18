/*
===========================================================
Question 2 – GDP Growth Ranking (2011–2012)
===========================================================
Task:
List countries ranked 10th to 12th within each continent 
based on their annual GDP per capita growth from 2011 to 2012.
-----------------------------------------------------------
Growth Formula:
((GDP_2012 - GDP_2011) / GDP_2011) * 100
-----------------------------------------------------------
Required Columns:
- rank
- continent_name
- country_code
- country_name
- growth_percent
===========================================================
*/

WITH ranked AS (
    SELECT 
        cm.continent_code,
        pc2011.country_code,
        ((pc2012.gdp_per_capita - pc2011.gdp_per_capita) / pc2011.gdp_per_capita) AS growth,
        RANK() OVER (
            PARTITION BY cm.continent_code
            ORDER BY ((pc2012.gdp_per_capita - pc2011.gdp_per_capita) / pc2011.gdp_per_capita) DESC
        ) AS rnk
    FROM dbo.per_capita pc2011
    JOIN dbo.per_capita pc2012 
        ON pc2011.country_code = pc2012.country_code
       AND pc2011.year = 2011
       AND pc2012.year = 2012
    JOIN dbo.continent_map cm 
        ON pc2011.country_code = cm.country_code
)
SELECT 
    rnk.rnk AS rank,
    ctt.continent_name,
    cn.country_code,
    cn.country_name,
    CONCAT(FORMAT(ROUND(rnk.growth * 100, 2), 'N2'), '%') AS growth_percent
FROM ranked rnk
JOIN dbo.continents ctt 
    ON rnk.continent_code = ctt.continent_code
JOIN dbo.countries cn 
    ON rnk.country_code = cn.country_code
WHERE rnk.rnk BETWEEN 10 AND 12
ORDER BY ctt.continent_name, rnk.rnk;

/*
-----------------------------------------------------------
Explanation:
1. The GDP per capita data for 2011 and 2012 was combined from the per_capita table for each country.
2. The GDP growth percentage between these two years was then calculated for all countries.
3. The continent_map table was joined to associate each country with its respective continent.
4. The RANK() function with PARTITION BY was applied to rank countries by their growth rate within each continent.
5. The query was filtered to include only countries ranked from 10 to 12 per continent.
6. Finally, the growth values were formatted as percentage strings for improved readability.
-----------------------------------------------------------
Example Output:
 rank | continent_name | country_code | country_name          | growth_percent
------+----------------+---------------+-----------------------+----------------
 10   | Africa         | RWA           | Rwanda                | 8.73%
 11   | Africa         | GIN           | Guinea                | 8.32%
 12   | Africa         | NGA           | Nigeria               | 8.09%
 10   | Asia           | UZB           | Uzbekistan             | 11.12%
 11   | Asia           | IRQ           | Iraq                   | 10.06%
 12   | Asia           | PHL           | Philippines            | 9.73%
 10   | Europe         | MNE           | Montenegro             | -2.93%
 11   | Europe         | SWE           | Sweden                 | -3.02%
 12   | Europe         | ISL           | Iceland                | -3.84%
 10   | North America  | GTM           | Guatemala              | 2.71%
 11   | North America  | HND           | Honduras               | 2.71%
 12   | North America  | ATG           | Antigua and Barbuda    | 2.52%
 10   | Oceania        | FJI           | Fiji                   | 3.29%
 11   | Oceania        | TUV           | Tuvalu                 | 1.27%
 12   | Oceania        | KIR           | Kiribati               | 0.04%
 10   | South America  | ARG           | Argentina              | 5.67%
 11   | South America  | PRY           | Paraguay               | -3.62%
 12   | South America  | BRA           | Brazil                 | -9.83%
-----------------------------------------------------------
Comment:
This query demonstrates window functions (RANK) and 
year-over-year growth calculations using self-joins.
It’s useful for comparing economic performance by region.
-----------------------------------------------------------
*/