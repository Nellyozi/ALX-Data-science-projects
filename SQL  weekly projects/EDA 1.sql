SHOW TABLES;
USE md_water_services;

SELECT * 
FROM location;

SELECT *
FROM visits;

SELECT  DISTINCT type_of_water_source
FROM water_source;

SELECT *
FROM visits
where time_in_queue > 500;

SELECT *
FROM water_source
where source_id in ('AkRu05234224', 'HaZa21742224');

SELECT *
FROM 
water_source
where source_id = 'AkRu05234224' OR source_id = 'HaZa21742224';


SELECT *
FROM water_quality
WHERE subjective_quality_score >= 10 AND visit_count >= 2;

SELECT *
FROM well_pollution;

SELECT *
FROM well_pollution
where results = 'clean' AND biological > 0.01;

SELECT * 
FROM well_pollution
WHERE  description like 'clean %';


 CREATE TABLE
 md_water_services.well_pollution_copy
 AS (
 SELECT
 *
 FROM
 md_water_services.well_pollution);

SET SQL_SAFE_UPDATES = 0;

 UPDATE
 well_pollution_copy
 SET
 description = 'Bacteria: E. coli'
 WHERE
 description = 'Clean Bacteria: E. coli';
 
 UPDATE
 well_pollution_copy
 SET
 description = 'Bacteria: Giardia Lamblia'
 WHERE
 description = 'Clean Bacteria: Giardia Lamblia';
 
  UPDATE
 well_pollution_copy
 SET
 results = 'Contaminated: Biological'
 WHERE
 biological > 0.01 AND results = 'Clean';
 
  SELECT
 *
 FROM
 well_pollution_copy
 WHERE
 description LIKE "Clean_%"
 OR (results = "Clean" AND biological > 0.01);