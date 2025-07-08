-- 11:13 creating auditor report table 
DROP TABLE IF EXISTS `auditor_report`;
CREATE TABLE `auditor_report` (
`location_id` VARCHAR(32),
`type_of_water_source` VARCHAR(64),
`true_water_source_score` int DEFAULT NULL,
`statements` VARCHAR(255)
);

-- 11:44 Retrieve location_id and true_water_source_score from auditor_report table
SELECT auditor_report.location_id,
       auditor_report.true_water_source_score
FROM auditor_report;

-- 11:53 Retrieve location_id and true_water_source_score from auditor_report, and location_id and record_id from visits by joining the tables
SELECT
    auditor_report.location_id,
    auditor_report.true_water_source_score,
    visits.location_id,
    visits.record_id
FROM
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id; 
    
    
    
-- 12:04 Retrieve location_id and true_water_source_score from auditor_report, and location_id and record_id from visits by joining the tables
SELECT
    auditor_report.location_id,
    auditor_report.true_water_source_score,
    visits.location_id,
    visits.record_id,
    water_quality.subjective_quality_score
FROM  
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id
JOIN
    water_quality
ON
    visits.record_id = water_quality.record_id;


-- 12:17 Retrieve specified columns by joining auditor_report, visits, and water_quality tables
SELECT
    auditor_report.location_id AS audit_location,
    auditor_report.true_water_source_score,
    visits.location_id AS visit_location,
    visits.record_id,
    water_quality.subjective_quality_score
FROM
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id
JOIN
    water_quality
ON
    visits.record_id = water_quality.record_id; 
 
 -- 12:17 retrieve cleaned up columns and renamed scores by joining auditor_report, visits, and water_quality tables
SELECT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS employee_score
FROM
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id
JOIN
    water_quality
ON
    visits.record_id = water_quality.record_id; 
    
    -- 12:19 Retrieve cleaned up columns and renamed scores by joining auditor_report, visits, and water_quality tables
SELECT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS employee_score
FROM
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id
JOIN
    water_quality
ON
    visits.record_id = water_quality.record_id
LIMIT 10000; 

-- 12:28 Retrieve data for analysis, including location_id, record_id, auditor_score, and surveyor_score
SELECT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id
JOIN
    water_quality
ON
    visits.record_id = water_quality.record_id
WHERE
    water_quality.subjective_quality_score = auditor_report.true_water_source_score;

-- 12:30
SELECT
    visits.location_id,     
    visits.record_id,     
    auditor_report.true_water_source_score AS auditor_score,     
    water_quality.subjective_quality_score AS surveyor_score 
FROM auditor_report 
JOIN visits 
ON auditor_report.location_id = visits.location_id 
JOIN water_quality 
ON visits.record_id = water_quality.record_id 
WHERE water_quality.subjective_quality_score <> auditor_report.true_water_source_score     
AND visits.visit_count = 1;


-- 13:02
SELECT
    visits.location_id,
    visits.record_id,
    water_source.type_of_water_source AS survey_source, -- Select water source type from water_source table and rename it as survey_source
    auditor_report.type_of_water_source AS auditor_source, -- Select water source type from auditor_report table and rename it as auditor_source
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id
JOIN
    water_quality
ON
    visits.record_id = water_quality.record_id
JOIN
    water_source
ON
    water_source.source_id = water_source.source_id -- Join with water_source table using source_id
WHERE
    water_quality.subjective_quality_score <> auditor_report.true_water_source_score
    AND visits.visit_count = 1;


-- 13:15 remove the join 
SELECT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id
JOIN
    water_quality
ON
    visits.record_id = water_quality.record_id
WHERE
    water_quality.subjective_quality_score <> auditor_report.true_water_source_score
    AND visits.visit_count = 1;


-- 13:26 Retrieve incorrect records and link them to the assigned employees
SELECT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score,
    visits.assigned_employee_id -- Include assigned employee ID in the results
FROM
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id
JOIN
    water_quality
ON
    visits.record_id = water_quality.record_id
WHERE
    water_quality.subjective_quality_score <> auditor_report.true_water_source_score
    AND visits.visit_count = 1;

-- 13:41 -- This query retrieves discrepancies in the type_of_water_source between the auditor_report and water_source tables,
-- and links these incorrect records to the corresponding employee names from the employees table for better identification.
SELECT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score,
    employee.employee_name AS assigned_employee_name
FROM
    auditor_report
JOIN
    visits
ON
    auditor_report.location_id = visits.location_id
JOIN
    water_quality
ON
    visits.record_id = water_quality.record_id
JOIN
    employee
ON
    visits.assigned_employee_id = employee.assigned_employee_id
WHERE
    water_quality.subjective_quality_score <> auditor_report.true_water_source_score
    AND visits.visit_count = 1;
    
    -- 13:57 creating a CTE
    WITH Incorrect_records AS (
    SELECT
        visits.location_id,
        visits.record_id,
        auditor_report.true_water_source_score AS auditor_score,
        water_quality.subjective_quality_score AS surveyor_score,
        employee.employee_name AS assigned_employee_name
    FROM
        auditor_report
    JOIN
        visits
    ON
        auditor_report.location_id = visits.location_id
    JOIN
        water_quality
    ON
        visits.record_id = water_quality.record_id
    JOIN
        employee
    ON
        visits.assigned_employee_id = employee.assigned_employee_id
    WHERE
        water_quality.subjective_quality_score <> auditor_report.true_water_source_score
        AND visits.visit_count = 1
)
SELECT * FROM Incorrect_records;

-- 14:02 
WITH Incorrect_records AS (
    SELECT
        visits.location_id,
        visits.record_id,
        auditor_report.true_water_source_score AS auditor_score,
        water_quality.subjective_quality_score AS surveyor_score,
        employee.employee_name AS assigned_employee_name
    FROM
        auditor_report
    JOIN
        visits
    ON
        auditor_report.location_id = visits.location_id
    JOIN
        water_quality
    ON
        visits.record_id = water_quality.record_id
    JOIN
        employee
    ON
        visits.assigned_employee_id = employee.assigned_employee_id
    WHERE
        water_quality.subjective_quality_score <> auditor_report.true_water_source_score
        AND visits.visit_count = 1
)
SELECT DISTINCT assigned_employee_name
FROM Incorrect_records
ORDER BY assigned_employee_name;
  
-- 14:07
WITH Incorrect_records AS (
    SELECT
        visits.location_id,
        visits.record_id,
        auditor_report.true_water_source_score AS auditor_score,
        water_quality.subjective_quality_score AS surveyor_score,
        employee.employee_name AS assigned_employee_name
    FROM
        auditor_report
    JOIN
        visits
    ON
        auditor_report.location_id = visits.location_id
    JOIN
        water_quality
    ON
        visits.record_id = water_quality.record_id
    JOIN
        employee
    ON
        visits.assigned_employee_id = employee.assigned_employee_id
    WHERE
        water_quality.subjective_quality_score <> auditor_report.true_water_source_score
        AND visits.visit_count = 1
)
SELECT 
    assigned_employee_name,
    COUNT(*) AS mistake_count
FROM 
    Incorrect_records
GROUP BY 
    assigned_employee_name
ORDER BY 
    mistake_count DESC, assigned_employee_name;
    
    -- 14:28
   -- Step 1: Create VIEW for Incorrect_records
CREATE VIEW Incorrect_records AS
SELECT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score,
    employee.employee_name AS assigned_employee_name
FROM
    auditor_report
JOIN
    visits ON auditor_report.location_id = visits.location_id
JOIN
    water_quality ON visits.record_id = water_quality.record_id
JOIN
    employee ON visits.assigned_employee_id = employee.assigned_employee_id
WHERE
    water_quality.subjective_quality_score <> auditor_report.true_water_source_score
    AND visits.visit_count = 1;

-- Step 2: Calculate error_count
WITH error_count AS (
    SELECT
        assigned_employee_name,
        COUNT(*) AS number_of_mistakes
    FROM
        Incorrect_records  -- This view contains records where surveyor and auditor scores differ
    GROUP BY
        assigned_employee_name
),

-- Step 3: Calculate average error count
avg_error AS (
    SELECT AVG(number_of_mistakes) AS avg_error_count_per_empl
    FROM error_count
)

-- Step 4: Compare each employee's error count with the average
SELECT
    ec.assigned_employee_name,
    ec.number_of_mistakes
FROM
    error_count ec, avg_error ae
WHERE
    ec.number_of_mistakes > ae.avg_error_count_per_empl
ORDER BY
    ec.number_of_mistakes DESC;
    
-- 14:31
-- Assuming Incorrect_records VIEW has already been created

WITH error_count AS ( 
    -- This CTE calculates the number of mistakes each employee made
    SELECT
        assigned_employee_name,
        COUNT(*) AS number_of_mistakes
    FROM
        Incorrect_records
    /* Incorrect_records is a view that joins the audit report to the database
       for records where the auditor and employees scores are different*/
    GROUP BY
        assigned_employee_name
)
-- Query to test the CTE
SELECT * FROM error_count
ORDER BY number_of_mistakes DESC;
    
-- 14:35

    
    
    
    
    
    
    
    
    