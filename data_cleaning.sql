USE CodeChallenge;
GO

-- 1️. Adjust data types for per_capita
ALTER TABLE dbo.per_capita
ALTER COLUMN country_code NVARCHAR(10) NOT NULL;

ALTER TABLE dbo.per_capita
ALTER COLUMN year INT NOT NULL;

ALTER TABLE dbo.per_capita
ALTER COLUMN gdp_per_capita DECIMAL(18,2) NULL;

-- 2️. Verify table structures
EXEC sp_help 'dbo.continents';
EXEC sp_help 'dbo.countries';
EXEC sp_help 'dbo.continent_map';
EXEC sp_help 'dbo.per_capita';

-- 3️. Check row counts
SELECT 'continents' AS table_name, COUNT(*) AS total_rows FROM dbo.continents
UNION ALL
SELECT 'countries', COUNT(*) FROM dbo.countries
UNION ALL
SELECT 'continent_map', COUNT(*) FROM dbo.continent_map
UNION ALL
SELECT 'per_capita', COUNT(*) FROM dbo.per_capita;

-- 4️. Find invalid or duplicate data in continent_map
SELECT * 
FROM continent_map 
WHERE country_code IS NULL OR continent_code IS NULL;

SELECT country_code, COUNT(*) AS cnt 
FROM continent_map 
GROUP BY country_code 
HAVING COUNT(*) > 1;

-- 5️. Remove NULLs and duplicates
DELETE FROM continent_map
WHERE country_code IS NULL OR continent_code IS NULL;

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY country_code ORDER BY continent_code) AS rn
    FROM continent_map
)
DELETE FROM cte WHERE rn > 1;

-- 6️. Make columns NOT NULL
ALTER TABLE dbo.continent_map
ALTER COLUMN country_code NVARCHAR(10) NOT NULL;

ALTER TABLE dbo.continent_map
ALTER COLUMN continent_code NVARCHAR(2) NOT NULL;

-- 7️. Check column definitions for country_code
SELECT t.name AS table_name, c.name AS column_name, ty.name AS data_type, c.max_length
FROM sys.columns c
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
JOIN sys.tables t ON c.object_id = t.object_id
WHERE c.name = 'country_code';

-- 8️. Align NVARCHAR length across tables
ALTER TABLE dbo.countries
ALTER COLUMN country_code NVARCHAR(10) NOT NULL;

ALTER TABLE dbo.per_capita
ALTER COLUMN country_code NVARCHAR(10) NOT NULL;

-- 9️. Add Primary and Foreign Keys
-- Continents
ALTER TABLE dbo.continents
ADD CONSTRAINT PK_continents PRIMARY KEY (continent_code);

-- Countries
ALTER TABLE dbo.countries
ADD CONSTRAINT PK_countries PRIMARY KEY (country_code);

-- Continent_map
ALTER TABLE dbo.continent_map
ADD CONSTRAINT PK_continent_map PRIMARY KEY (country_code, continent_code);

ALTER TABLE dbo.continent_map
ADD CONSTRAINT FK_continent_map_country
FOREIGN KEY (country_code) REFERENCES dbo.countries(country_code);

ALTER TABLE dbo.continent_map
ADD CONSTRAINT FK_continent_map_continent
FOREIGN KEY (continent_code) REFERENCES dbo.continents(continent_code);

-- Per_capita
ALTER TABLE dbo.per_capita
ADD CONSTRAINT PK_per_capita PRIMARY KEY (country_code, year);

ALTER TABLE dbo.per_capita
ADD CONSTRAINT FK_per_capita_country
FOREIGN KEY (country_code) REFERENCES dbo.countries(country_code);

-- ✅ Final check for all constraints
SELECT 
    t.name AS table_name,
    i.name AS pk_name,
    c.name AS column_name
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables t ON t.object_id = i.object_id
WHERE i.is_primary_key = 1
ORDER BY t.name;

SELECT 
    f.name AS fk_name,
    OBJECT_NAME(f.parent_object_id) AS child_table,
    COL_NAME(fc.parent_object_id,fc.parent_column_id) AS child_column,
    OBJECT_NAME(f.referenced_object_id) AS parent_table,
    COL_NAME(fc.referenced_object_id,fc.referenced_column_id) AS parent_column
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc 
    ON f.object_id = fc.constraint_object_id
ORDER BY child_table;
