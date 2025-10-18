# -SQL-GDP-Analysis
________________________________________
🎯 Project Goal
The purpose of this project is to demonstrate practical SQL skills in analyzing macroeconomic data — specifically, GDP per capita by country and continent.
The project covers the complete data workflow: from database creation and cleaning to performing analytical SQL queries using window functions, aggregations, and ranking.
The results showcase the ability to solve typical analytical tasks encountered in real-world data analysis roles.
________________________________________
🗂️ Data
Source: Simulated dataset provided as part of the Braintree Analytics Code Challenge.
Scope: Four interrelated tables containing country, continent, and GDP per capita data for the years 2004–2012.
Structure:
•	continents — list of continents with corresponding codes
•	countries — reference table containing country names and codes
•	continent_map — mapping of countries to continents
•	per_capita — GDP per capita values by country and year
Format: CSV files → imported into SQL Server Management Studio (SSMS)
________________________________________
🔧 Tools & Technologies
•	SQL Server Management Studio (SSMS) — main environment for writing, executing, and testing SQL queries
•	Excel — used for result validation and formatting
•	GitHub — for version control and project publication
________________________________________
📁 Project Structure
File / Folder	Description
data_csv/	Folder containing CSV datasets (continent_map.csv, continents.csv, countries.csv, per_capita.csv)
SQL Query/	Folder with SQL task solutions (01_question.sql–07_question.sql)
create_database.sql	Script for database creation and CSV import
data_cleaning.sql	Script for data cleaning and validation (handling duplicates and NULLs)
results.txt	Final results of all SQL queries
README.md	Project documentation and description
LICENSE	License file for project distribution
________________________________________
📝 Analysis Process
1.	Database Creation
Imported CSV files and built relational table structures in SQL Server.
2.	Data Cleaning
Removed duplicates, replaced NULL values, and validated data integrity.
3.	Task Analysis
o	Calculated GDP growth dynamics
o	Compared countries and continents
o	Computed GDP shares and aggregated indicators
o	Applied window functions RANK() and SUM() OVER() for ranking and cumulative calculations
4.	Output Formatting
o	Monetary values rounded to two decimals and formatted with $
o	Percentages displayed with two decimal points and % symbol
________________________________________
📈 Key Results
Task	Description	Key Finding
1	Data validation and duplicate removal	All country codes are unique
2	Top countries by GDP growth (2011–2012)	Ranked positions 10–12 within each continent
3	GDP per capita share (2012)	Asia — 28.33%, Europe — 42.24%, Rest of World — 29.43%
4a–4b	Case-sensitive / insensitive search (“an”)	Difference: 68 vs 66 countries
5	GDP totals for countries missing 2012 data	Summaries for 2004–2011
6	Running total by continent (2009)	6 countries with cumulative ≥ $70,000
7	Highest average GDP per continent	Minor inconsistencies detected in Africa and Asia
________________________________________
📊 Example Output (Task 6 — Running Total 2009)
Continent 	   Country	    GDP per Capita	Running Total
Africa	       Libya	      $10,455.57	    $70,227.16
Asia	         Kuwait	      $37,160.54	    $73,591.81
Europe	       Switzerland	$65,790.07    	$84,673.58
North America	 Aruba	      $24,639.94	    $84,504.67
Oceania	       New Zealand	$27,474.33	    $84,623.91
South America	 Ecuador	    $4,236.78	      $72,315.82
________________________________________
💡 Conclusions
•	Demonstrated strong proficiency in SQL-based data analysis.
•	Applied window functions, subqueries, conditional logic, and aggregations.
•	Identified discrepancies in the reference dataset — results varied due to updated GDP values.
•	The project serves as an example of macroeconomic data analysis using pure SQL without external analytical tools.
