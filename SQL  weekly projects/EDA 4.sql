--  07:58 Join location table to visits table
SELECT
    location.province_name,
    location.town_name,
    visits.visit_count,
    location.location_id
FROM
    location
JOIN
    visits ON visits.location_id = location.location_id
WHERE 
    visits.visit_count = 1;
-- Explanation:
-- This query joins the location and visits tables
-- It selects province_name and town_name from location, and visit_count from visits
-- The join is based on matching location_id in both tables
-- It filters for visits with a visit_count of 1

-- 08:04 Join location, visits, and water_source tables using full table names
SELECT
    location.province_name,
    location.town_name,
    visits.visit_count,
    location.location_id,
    water_source.source_id,
    water_source.type AS water_source_type
FROM
    location
JOIN
    visits ON visits.location_id = location.location_id
JOIN
    water_source ON water_source.location_id = location.location_id
WHERE 
    visits.visit_count = 1;

-- Explanation:
-- This query joins the location, visits, and water_source tables
-- It uses full table names instead of aliases for clarity
-- The joins are based on the location_id column present in all three tables
-- It selects specific columns from each table
-- The query filters for locations with exactly one visit
-- Adjust column names if they differ in your actual schema


-- 08:04 
SELECT
    location.province_name,
    location.town_name,
    visits.visit_count,
    location.location_id,
    water_source.type_of_water_source,
    water_source.number_of_people_served
FROM
    location
JOIN
    visits ON visits.location_id = location.location_id
JOIN
    water_source ON visits.source_id = water_source.source_id
WHERE 
    visits.visit_count = 1;

-- Explanation:
-- This query correctly joins the location, visits, and water_source tables
-- It selects specific columns from each table as per the requirement
-- The first join is between location and visits based on location_id
-- The second join is between visits and water_source based on source_id
-- The query filters for locations with exactly one visit

-- 08:21
SELECT
    location.province_name,
    location.town_name,
    visits.visit_count,
    location.location_id,
    water_source.type_of_water_source,
    water_source.number_of_people_served
FROM
    location
JOIN
    visits ON visits.location_id = location.location_id
JOIN
    water_source ON visits.source_id = water_source.source_id
WHERE 
    visits.location_id = 'AkHa00103'
ORDER BY 
    visits.visit_count DESC;

-- Explanation:
-- This query joins the location, visits, and water_source tables
-- It selects specific columns from each table
-- The joins remain the same as in the previous query
-- We've changed the WHERE clause to focus on a specific location_id
-- We've added an ORDER BY clause to sort the results by visit_count in descending order
-- This will show all visits to the specified location, including those with visit_count > 1

-- 08:27 
SELECT
    location.province_name,
    location.town_name,
    visits.visit_count,
    location.location_id,
    water_source.type_of_water_source,
    water_source.number_of_people_served
FROM
    location
JOIN
    visits ON visits.location_id = location.location_id
JOIN
    water_source ON visits.source_id = water_source.source_id
WHERE 
    visits.location_id = 'AkHa00103' 
    AND visits.visit_count = 1
ORDER BY 
    visits.visit_count DESC;

-- Explanation:
-- This query selects records for a specific location (`location_id = 'AkHa00103'`) but only includes those where `visit_count = 1`.
-- The aggregation issue is avoided by filtering out rows where `visit_count` is not equal to 1.
-- The `ORDER BY` clause remains for sorting, but since the `visit_count` will always be 1 in this case, the sorting won't make much difference in this scenario.

-- 08:31
SELECT
    location.province_name,
    location.town_name,
    visits.visit_count,
    location.location_id,
    water_source.type_of_water_source,
    water_source.number_of_people_served
FROM
    location
JOIN
    visits ON visits.location_id = location.location_id
JOIN
    water_source ON visits.source_id = water_source.source_id
WHERE 
    visits.visit_count = 1
ORDER BY 
    visits.visit_count DESC;
-- We removed the previous WHERE condition filtering by location_id.
-- The query now filters records where visits.visit_count = 1 directly.

-- 08:37 
SELECT
    location.province_name,
    location.town_name,
    water_source.type_of_water_source,
    water_source.number_of_people_served
FROM
    location
JOIN
    visits ON visits.location_id = location.location_id
JOIN
    water_source ON visits.source_id = water_source.source_id
WHERE 
    visits.visit_count = 1
ORDER BY 
    visits.visit_count DESC;
-- Removed location_id and visit_count columns as instructed 

-- 08:38
SELECT
    location.province_name,
    location.town_name,
    location.location_type,
    water_source.type_of_water_source,
    water_source.number_of_people_served,
    visits.time_in_queue
FROM
    location
JOIN
    visits ON visits.location_id = location.location_id
JOIN
    water_source ON visits.source_id = water_source.source_id
WHERE 
    visits.visit_count = 1
ORDER BY 
    visits.visit_count DESC;
-- Added location_type and time_in_queue columns to the results set

-- 08:56
-- This table assembles data from different tables into one to simplify analysis
SELECT
water_source.type_of_water_source,
location.town_name,
location.province_name,
location.location_type,
water_source.number_of_people_served,
visits.time_in_queue,
well_pollution.results
FROM
visits
LEFT JOIN
well_pollution
ON well_pollution.source_id = visits.source_id
INNER JOIN
location
ON location.location_id = visits.location_id
INNER JOIN
water_source
ON water_source.source_id = visits.source_id
WHERE
visits.visit_count = 1;

-- 09:05
CREATE VIEW combined_analysis_table AS
-- This view assembles data from different tables into one to simplify analysis
SELECT
water_source.type_of_water_source AS source_type,
location.town_name,
location.province_name,
location.location_type,
water_source.number_of_people_served AS people_served,
visits.time_in_queue,
well_pollution.results
FROM
visits
LEFT JOIN
well_pollution
ON well_pollution.source_id = visits.source_id
INNER JOIN
location
ON location.location_id = visits.location_id
INNER JOIN
water_source
ON water_source.source_id = visits.source_id
WHERE
visits.visit_count = 1;

-- 09:21execute the cte first 
WITH province_totals AS (-- This CTE calculates the population of each province
SELECT
province_name,
SUM(people_served) AS total_ppl_serv
FROM
combined_analysis_table
GROUP BY
province_name
)
SELECT
ct.province_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / pt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table ct
JOIN
province_totals pt ON ct.province_name = pt.province_name
GROUP BY
ct.province_name
ORDER BY
ct.province_name;


-- 09:21
WITH province_totals AS (
    SELECT
        province_name,
        SUM(people_served) AS total_ppl_serv
    FROM
        combined_analysis_table
    GROUP BY
        province_name
)
SELECT
    *
FROM
    province_totals;  
-- This query selects all columns from the CTE province_totals

-- 10:01
WITH town_totals AS (-- This CTE calculates the population of each town
-- Since there are two Harare towns, we have to group by province_name and town_name
SELECT province_name, town_name, SUM(people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name,town_name
)
SELECT
ct.province_name,
ct.town_name,
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table ct
JOIN -- Since the town names are not unique, we have to join on a composite key
town_totals tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
GROUP BY --  We group by province first, then by town.
ct.province_name,
ct.town_name
ORDER BY
ct.town_name;

-- 10:17 
CREATE TEMPORARY TABLE town_aggregated_water_access
WITH town_totals AS (-- This CTE calculates the population of each town
-- Since there are two Harare towns, we have to group by province_name and town_name
SELECT province_name, town_name, SUM(people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name,town_name
)
SELECT
ct.province_name,
ct.town_name,
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table ct
JOIN -- Since the town names are not unique, we have to join on a composite key
town_totals tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
GROUP BY --  We group by province first, then by town.
ct.province_name,
ct.town_name
ORDER BY
ct.town_name;

-- 10:19 
select * 
from 
town_aggregated_water_access;

-- 10:20 
SELECT * 
FROM 
    town_aggregated_water_access 
ORDER BY 
    river DESC;  
-- Ordering the results by river in descending order to confirm findings for Sokoto

-- 10:24 
SELECT * 
FROM 
    town_aggregated_water_access 
ORDER BY 
    province_name, river DESC;  
    -- First ordering by province_name, then by river in descending order
    
    -- 10:25 
SELECT
province_name,
town_name,
ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) * 100,0) AS Pct_broken_taps
FROM
town_aggregated_water_access; 

-- People with broken taps
SELECT
province_name,
town_name,
ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) * 100,0) AS Pct_broken_taps
FROM
town_aggregated_water_access;
-- 10:49 
/* CREATE TABLE Project_progress (
Project_id SERIAL PRIMARY KEY,
source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
Address VARCHAR(50),
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
Improvement VARCHAR(50),
Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
Date_of_completion DATE,
Comments TEXT
); */ 

-- 11:04 
--  Project_progress_query
SELECT
location.address,
location.town_name,
location.province_name,
water_source.source_id,
water_source.type_of_water_source,
well_pollution.results
FROM
water_source
LEFT JOIN
well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
visits ON water_source.source_id = visits.source_id
INNER JOIN
location ON location.location_id = visits.location_id ; 

-- 11:15 
SELECT
location.address,
location.town_name,
location.province_name,
water_source.source_id,
water_source.type_of_water_source,
well_pollution.results
FROM
water_source
LEFT JOIN
well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
visits ON water_source.source_id = visits.source_id
INNER JOIN
location ON location.location_id = visits.location_id
WHERE  
    visits.visit_count = 1                                        
    AND (  
            (water_source.type_of_water_source = 'well'          
                 AND well_pollution.results != 'Clean')  
         OR water_source.type_of_water_source IN                  
                ('river', 'tap_in_home_broken')  
         OR (water_source.type_of_water_source = 'shared_tap'        
                 AND visits.time_in_queue >= 30)  
) LIMIT 26000; 
-- Ensure the WHERE clause is correctly filtering sources to meet the specified criteria.

-- 11:33
SELECT
    location.address,
    location.town_name,
    location.province_name,
    water_source.source_id,
    water_source.type_of_water_source,
    well_pollution.results,
    CASE
        WHEN well_pollution.results IS NULL THEN 'No data'
        WHEN well_pollution.results = 'Contaminated: Biological' THEN 'Install UV filter'
        WHEN well_pollution.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        ELSE NULL
    END AS Improvement
FROM
    water_source
LEFT JOIN
    well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
    visits ON water_source.source_id = visits.source_id
INNER JOIN
    location ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1;

-- 11:47 
SELECT
    location.address,
    location.town_name,
    location.province_name,
    water_source.source_id,
    water_source.type_of_water_source,
    well_pollution.results,
    CASE
        WHEN water_source.type_of_water_source = 'river' THEN 'Drill well'  -- First check for river sources
        WHEN well_pollution.results = 'Contaminated: Biological' THEN 'Install UV filter'
        WHEN well_pollution.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        WHEN well_pollution.results IS NULL THEN 'No data'  -- Handle NULL after other checks
        ELSE NULL
    END AS Improvement
FROM
    water_source
LEFT JOIN
    well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
    visits ON water_source.source_id = visits.source_id
INNER JOIN
    location ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1;
    
    -- 11:57
  SELECT
    location.address,
    location.town_name,
    location.province_name,
    water_source.source_id,
    water_source.type_of_water_source,
    well_pollution.results,
    CASE
        WHEN water_source.type_of_water_source = 'river' THEN 'Drill well'
        WHEN well_pollution.results = 'Contaminated: Biological' THEN 'Install UV filter'
        WHEN well_pollution.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        WHEN water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue > 30 
            THEN CONCAT('Install ', FLOOR(visits.time_in_queue / 30), ' taps nearby')  -- Calculate taps for shared taps
        WHEN well_pollution.results IS NULL THEN 'No data'
        ELSE NULL
    END AS Improvement
FROM
    water_source
LEFT JOIN
    well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
    visits ON water_source.source_id = visits.source_id
INNER JOIN
    location ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1;

-- 12:12   
SELECT
    location.address,
    location.town_name,
    location.province_name,
    water_source.source_id,
    water_source.type_of_water_source,
    well_pollution.results,
    CASE
        WHEN water_source.type_of_water_source = 'river' THEN 'Drill well'
        WHEN well_pollution.results = 'Contaminated: Biological' THEN 'Install UV filter'
        WHEN well_pollution.results = 'Contaminated: Chemical' THEN 'Install RO filter'
        WHEN water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue > 30 
            THEN CONCAT('Install ', FLOOR(visits.time_in_queue / 30), ' taps nearby')
        WHEN water_source.type_of_water_source = 'tap_in_home_broken' THEN 'Diagnose local infrastructure'  -- Inspect broken in-home taps
        WHEN well_pollution.results IS NULL THEN 'No data'  -- Ensure no NULL values in the results
        ELSE NULL
    END AS Improvement
FROM
    water_source
LEFT JOIN
    well_pollution ON water_source.source_id = well_pollution.source_id
INNER JOIN
    visits ON water_source.source_id = visits.source_id
INNER JOIN
    location ON location.location_id = visits.location_id
WHERE
    visits.visit_count = 1;

