SELECT
employee_name,
CONCAT(
LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov') AS new_email
FROM
md_water_services.employee;
UPDATE
 md_water_services.employee
 SET
 email =  CONCAT( LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov')
 WHERE isnull(email);
SET SQL_SAFE_UPDATES = 0;
UPDATE
 md_water_services.employee
 SET
 email =  CONCAT( LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov')
 WHERE isnull(email);
SELECT * FROM md_water_services.employee;
SELECT LENGTH(phone_number)
 from
 md_water_services.employee;
SELECT LENGTH(phone_number)
 from
 md_water_services.employee;
 
 
SELECT 
 province_name, COUNT(province_name) AS number_of_rec_per_province
 from location
 GROUP BY province_name
 ORDER BY COUNT(province_name) DESC;
 
 SELECT
 province_name, town_name, COUNT(town_name) as records_per_town
 FROM location
 GROUP BY province_name,town_name
 ORDER BY province_name, COUNT(town_name) DESC;
 
 SELECT
 location_type, COUNT(location_type) AS number_of_location_type
 FROM
 location
 GROUP BY location_type
 ORDER BY COUNT(location_type) DESC;
 
 SELECT * 
 FROM water_source
 where type_of_water_source = 'tap_in_home';
 SELECT
 type_of_water_source, sum(number_of_people_served) AS number_of_people_served_per_type
 FROM water_source
 GROUP BY type_of_water_source
 ORDER BY sum(number_of_people_served) DESC;
 
 SELECT
sum(number_of_people_served)
 FROM
 water_source;
 
 SELECT
 type_of_water_source, ROUND(AVG(number_of_people_served),0) AS average_number_of_people
 FROM water_source
 GROUP BY type_of_water_source;
 
 SELECT
 type_of_water_source, sum(number_of_people_served)
 FROM
 water_source
 GROUP BY type_of_water_source
 ORDER BY sum(number_of_people_served) DESC;
 
 SELECT
 type_of_water_source, Round((sum(number_of_people_served)/27628140)*100,0) AS percentage_number_of_people_served
 FROM
 WATER_SOURCE
 GROUP BY type_of_water_source;
 
 SELECT
 type_of_water_source,
 sum(number_of_people_served) AS number_of_people,
 RANK() OVER (ORDER BY sum(number_of_people_served) DESC) AS rank_by_population
 FROM 
 water_source
 GROUP BY type_of_water_source;
 
 SELECT
 source_id,
 type_of_water_source,
 number_of_people_served,
 RANK() OVER(PARTITION BY type_of_water_source ORDER BY number_of_people_served DESC) AS rank_of_people_served
 FROM water_source;
 
 SELECT
      MIN(time_of_record) AS MINIMUM,
	 MAX(time_of_record) AS MAXIMUM,
	DATEDIFF(MAX(time_of_record),MIN(time_of_record) AS No_of_days_of_survey
    FROM visits;
    
     SELECT
    AVG(IF(time_in_queue = 0, NULL, time_in_queue)) AS average_time_in_queue
    FROM
    visits;
    
    SELECT
    DAYNAME(time_of_record) AS DAY_OF_THE_WEEK,
    ROUND(AVG(IF(time_in_queue = 0, null, time_in_queue)), 0) AS avg_queue_time
    FROM visits
    GROUP BY DAYNAME(time_of_record);
    
    SELECT
    HOUR(time_of_record) AS HOUR_OF_DAY,
    ROUND(AVG(IF(time_in_queue = 0, null, time_in_queue)), 0) AS avg_queue_time
    FROM visits
    GROUP BY HOUR(time_of_record)
    ORDER BY HOUR(time_of_record);
    SELECT
    TIME_FORMAT(TIME(time_of_record), "%H:00") AS Hour_of_the_day,
    ROUND(avg(if(time_in_queue = 0, null, time_in_queue)),0) AS avg_queue_time
    FROM visits
    GROUP BY TIME_FORMAT(TIME(time_of_record),  "%H:00")
    ORDER BY TIME_FORMAT(TIME(time_of_record), "%H:00"),
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = "Sunday" THEN time_in_queue
    ELSE NULL
    END),0);
    
/* PROJECT PART */
   CREATE TABLE `auditor_report` (
 `location_id` VARCHAR(32),
 `type_of_water_source` VARCHAR(64),
 `true_water_source_score` int DEFAULT NULL,
 `statements` VARCHAR(255)
 );
 
  /*SELECT
 md_water_services.auditor_report.location_id AS audit_location,
 md_water_services.auditor_report.true_water_source_score,
 visits.location_id AS visit_location,
 visits.record_id, subjective_quality
 FROM
 auditor_report
 JOIN
 visits
 ON auditor_report.location_id = visits.location_id
 JOIN
 water_qaulity
 ON water_quality.record_id = visits.record_id;/*