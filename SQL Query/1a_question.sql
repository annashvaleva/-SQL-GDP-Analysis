/*
===========================================================
Question 1a – Data Integrity Check: Duplicate Country Codes
===========================================================
Task:
Alphabetically list all country codes in the `continent_map` table 
that appear more than once. Display NULL country_code values as "FOO" 
and make this row appear first in the list.
-----------------------------------------------------------
Logic:
1. Group by country_code to find duplicates.
2. Replace NULL with 'FOO' using COALESCE().
3. Sort so that 'FOO' (originally NULL) appears first.
===========================================================
*/

SELECT 
    COALESCE(country_code, 'FOO') AS country_code
FROM dbo.continent_map
GROUP BY country_code
HAVING COUNT(*) > 1 OR country_code IS NULL
ORDER BY 
    CASE WHEN country_code IS NULL THEN 0 ELSE 1 END,  -- ensures 'FOO' appears first
    COALESCE(country_code, 'FOO');

/*
-----------------------------------------------------------
Expected Output:
- 'FOO' appears first if NULL values exist.
- Followed by alphabetically ordered duplicate country codes.
-----------------------------------------------------------
Actual Result:
(0 rows returned)

Comment:
No duplicates or NULL values found in `continent_map`.
This indicates that the dataset has already been cleaned.
Since PRIMARY and FOREIGN KEY constraints were successfully applied, 
SQL Server ensures there are no NULLs or duplicate country codes.
-----------------------------------------------------------
*/
