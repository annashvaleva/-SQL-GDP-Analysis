/* ============================================================
   QUESTION 4 — Substring Search ('an')
   ============================================================
   Objective:
   Find how many countries and what is the total GDP per capita
   for the year 2007 where the country name contains the substring
   'an'.

   Part (a) — Case-insensitive search
   ------------------------------------------------------------
   Logic:
   - Join per_capita and countries tables.
   - Filter only rows where year = 2007.
   - Use LOWER(country_name) LIKE '%an%' to ignore case.
   - Count countries and sum GDP per capita.
=============================================================== */

SELECT 
    COUNT(c.country_code) AS country_count,
    CONCAT('$', FORMAT(ROUND(SUM(pc.gdp_per_capita), 2), 'N2')) AS total_gdp_per_capita
FROM per_capita pc
JOIN countries c ON pc.country_code = c.country_code
WHERE pc.year = 2007
  AND LOWER(c.country_name) LIKE '%an%';

/*
---------------------------------------------------------------
RESULT (4a — Case-insensitive):
---------------------------------------------------------------
country_count | total_gdp_per_capita
------------------------------------
68            | $1,022,936.30
---------------------------------------------------------------
Explanation:
68 countries contain the substring 'an' in any case form
('an', 'An', 'AN', etc.). 
---------------------------------------------------------------
*/


/* ============================================================
   Part (b) — Case-sensitive search
   ------------------------------------------------------------
   Logic:
   - Same structure as (a).
   - Use COLLATE Latin1_General_CS_AS to make search case-sensitive.
   - Only lowercase 'an' is matched.
=============================================================== */

SELECT 
    COUNT(c.country_code) AS country_count,
    CONCAT('$', FORMAT(ROUND(SUM(pc.gdp_per_capita), 2), 'N2')) AS total_gdp_per_capita
FROM per_capita pc
JOIN countries c ON pc.country_code = c.country_code
WHERE pc.year = 2007
  AND c.country_name COLLATE Latin1_General_CS_AS LIKE '%an%';

/*
---------------------------------------------------------------
RESULT (4b — Case-sensitive):
---------------------------------------------------------------
country_count | total_gdp_per_capita
------------------------------------
66            | $979,600.69
---------------------------------------------------------------
Explanation:
Only lowercase 'an' was matched.
The following countries were excluded in case-sensitive mode:
  - Andorra
  - Angola
---------------------------------------------------------------
*/


/* ============================================================
   Diagnostic query — To show which countries matched pattern 'an'
   (case-sensitive version)
=============================================================== */

SELECT 
    c.country_code,
    c.country_name
FROM countries c
WHERE c.country_name COLLATE Latin1_General_CS_AS LIKE '%an%'
ORDER BY c.country_name;

/*
---------------------------------------------------------------
RESULT — Matching countries (case-sensitive):
---------------------------------------------------------------
AFG Afghanistan
ALB Albania
ASM American Samoa
ATG Antigua and Barbuda
AZE Azerbaijan
BGD Bangladesh
BTN Bhutan
BIH Bosnia and Herzegovina
BWA Botswana
CAN Canada
CSS Caribbean small states
CYM Cayman Islands
CAF Central African Republic
CHI Channel Islands
DOM Dominican Republic
CEA East Asia and the Pacific (IFC classification)
CEU Europe and Central Asia (IFC classification)
EUU European Union
FRO Faeroe Islands
FIN Finland
FRA France
DEU Germany
GHA Ghana
GRL Greenland
GUY Guyana
ISL Iceland
IRN Iran, Islamic Rep.
IRL Ireland
IMN Isle of Man
JPN Japan
JOR Jordan
KAZ Kazakhstan
LCN Latin America & Caribbean (all income levels)
LAC Latin America & Caribbean (developing only)
CLA Latin America and the Caribbean (IFC classification)
LBN Lebanon
LTU Lithuania
MHL Marshall Islands
MRT Mauritania
CME Middle East and North Africa (IFC classification)
MMR Myanmar
NLD Netherlands
NZL New Zealand
MNP Northern Mariana Islands
OMN Oman
PSS Pacific island small states
PAK Pakistan
PAN Panama
POL Poland
ROU Romania
RUS Russian Federation
RWA Rwanda
SMR San Marino
STP Sao Tome and Principe
SLB Solomon Islands
SSD South Sudan
LKA Sri Lanka
KNA St. Kitts and Nevis
VCT St. Vincent and the Grenadines
SSF Sub-Saharan Africa (all income levels)
SSA Sub-Saharan Africa (developing only)
CAA Sub-Saharan Africa (IFC classification)
SDN Sudan
SWZ Swaziland
CHE Switzerland
SYR Syrian Arab Republic
TJK Tajikistan
TZA Tanzania
THA Thailand
TTO Trinidad and Tobago
TKM Turkmenistan
TCA Turks and Caicos Islands
UGA Uganda
UZB Uzbekistan
VUT Vanuatu
VIR Virgin Islands (U.S.)
PSE West Bank and Gaza
---------------------------------------------------------------
*/