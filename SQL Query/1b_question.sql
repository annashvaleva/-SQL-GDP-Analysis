/*
===========================================================
Question 1b – Remove Duplicate Country Codes
===========================================================
Task:
For all countries that have multiple rows in the `continent_map` table,
delete all duplicates and leave only one record per country.
Keep the record with the alphabetically first `continent_code`.
-----------------------------------------------------------
Logic:
1. Identify countries that appear more than once.
2. Review which records are duplicated.
3. Use ROW_NUMBER() to keep only the first record per country.
4. Verify that no duplicates remain.
===========================================================
*/

-- Step 1. – Check for duplicates
SELECT country_code, COUNT(*) AS cnt
FROM dbo.continent_map
GROUP BY country_code
HAVING COUNT(*) > 1;

-- Step 2. – View all duplicated rows
SELECT *
FROM dbo.continent_map
WHERE country_code IN (
    SELECT country_code
    FROM dbo.continent_map
    GROUP BY country_code
    HAVING COUNT(*) > 1
)
ORDER BY country_code, continent_code;

-- Step 3. – Delete duplicates, keeping the first (alphabetically smallest) record
WITH duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY country_code ORDER BY continent_code ASC) AS rn
    FROM dbo.continent_map
)
DELETE FROM duplicates WHERE rn > 1;

-- Step 4. – Verify the cleanup
SELECT country_code, COUNT(*) AS cnt
FROM dbo.continent_map
GROUP BY country_code
HAVING COUNT(*) > 1;

/*
-----------------------------------------------------------
Expected Output:
- Before cleanup: list of countries with cnt > 1 (if duplicates existed).
- After cleanup: (0 rows returned) ? all duplicates removed.
-----------------------------------------------------------
Comment:
The ROW_NUMBER() approach safely keeps the first record per country 
based on alphabetical order of `continent_code`. 
After cleanup, each country appears only once in `continent_map`.
-----------------------------------------------------------
*/