 ---1.Create a new database
CREATE DATABASE CodeChallenge;
GO

USE CodeChallenge;
GO

---2. Create table: continents
Create table: continents
CREATE TABLE dbo.continents (
    continent_code NVARCHAR(2) NOT NULL PRIMARY KEY,
    continent_name NVARCHAR(50)
);
---3. Create table: countries
Create table: countries
CREATE TABLE dbo.countries (
    country_code NVARCHAR(10) NOT NULL PRIMARY KEY,
    country_name NVARCHAR(100)
);
---4. Create table: continent_map
Create table: continent_map
CREATE TABLE dbo.continent_map (
    country_code NVARCHAR(10) NULL,
    continent_code NVARCHAR(2) NULL
);
---5. Create table: per_capita
Create table: per_capita
CREATE TABLE dbo.per_capita (
    country_code NVARCHAR(10) NULL,
    year NVARCHAR(10) NULL,
    gdp_per_capita NVARCHAR(50) NULL
);


