-- Data Cleaning
SELECT * 
FROM Banking_Dataset.marketing_targets;

-- 1. Remove Duplicates 
-- 2. Standardize the Data 
-- 3. Remove any columns 

USE marketing_targets; 
CREATE TABLE marketing_targets_staging
LIKE Banking_Dataset.marketing_targets;

SELECT * 
FROM marketing_targets_staging; 

INSERT marketing_targets_staging
SELECT * 
FROM marketing_targets;

SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY age, job, marital, education,`default`, balance, housing, loan, contact,`day`, `month`, `year`,duration, campaign,
pdays, previous, poutcome, y) AS row_num
FROM marketing_targets_staging;

WITH duplicate_cte AS 
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY age, job, marital, education,`default`, balance, housing, loan, contact,`day`, `month`, `year`,duration, campaign,
pdays, previous, poutcome, y) AS row_num
FROM marketing_targets_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1; 



CREATE TABLE `marketing_targets_staging2` (
  `age` int DEFAULT NULL,
  `job` text,
  `marital` text,
  `education` text,
  `default` text,
  `balance` int DEFAULT NULL,
  `housing` text,
  `loan` text,
  `contact` text,
  `day` int DEFAULT NULL,
  `month` text,
  `year` int DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `campaign` int DEFAULT NULL,
  `pdays` int DEFAULT NULL,
  `previous` int DEFAULT NULL,
  `poutcome` text,
  `y` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM marketing_targets_staging2;

INSERT INTO marketing_targets_staging2
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY age, job, marital, education,`default`, balance, housing, loan, contact,`day`, `month`, `year`,duration, campaign,
pdays, previous, poutcome, y) AS row_num
FROM marketing_targets_staging; 

SELECT * 
FROM marketing_targets_staging2
WHERE row_num >1;

DELETE 
FROM marketing_targets_staging2
WHERE row_num >1;

SELECT * 
FROM marketing_targets_staging2;

-- 2. Standardize the Data 

SELECT DISTINCT  age
FROM marketing_targets_staging2;

SELECT DISTINCT job
FROM marketing_targets_staging2;

UPDATE marketing_targets_staging2
SET job = 'admin' 
WHERE job = "admin.";

UPDATE marketing_targets_staging2
SET job = 'management' 
WHERE job = "maB72:B88nagement";

UPDATE marketing_targets_staging2
SET job = 'housemaid'
WHERE job = 'maid';

SELECT  job, (TRIM(job))
FROM marketing_targets_staging2;

UPDATE marketing_targets_staging2
SET job = TRIM(job); 

SELECT  job, (TRIM(job))
FROM marketing_targets_staging2;

SELECT DISTINCT marital 
FROM marketing_targets_staging2;

SELECT *
FROM marketing_targets_staging2
WHERE education LIKE "secondary%";

UPDATE marketing_targets_staging2
SET education = 'secondary' 
WHERE education = "secondary.";

SELECT DISTINCT education 
FROM marketing_targets_staging2;

SELECT DISTINCT `default`, TRIM(TRAILING '.' FROM `default`)
FROM marketing_targets_staging2;

UPDATE marketing_targets_staging2
SET `default` = TRIM(TRAILING '.' FROM `default`)
WHERE `default` = 'no%';

SELECT DISTINCT balance
FROM marketing_targets_staging2
GROUP BY 1;

SELECT DISTINCT housing
FROM marketing_targets_staging2
GROUP BY 1;

SELECT DISTINCT loan
FROM marketing_targets_staging2
GROUP BY 1;

SELECT DISTINCT contact
FROM marketing_targets_staging2
GROUP BY 1;

SELECT `day`, `month`, `year`
FROM marketing_targets_staging2;

UPDATE marketing_targets_staging2 SET `month` = '1' WHERE `month`= "jan";
UPDATE marketing_targets_staging2 SET `month` = '2' WHERE `month`= "feb";
UPDATE marketing_targets_staging2 SET `month` = '3' WHERE `month`= "mar";
UPDATE marketing_targets_staging2 SET `month` = '4' WHERE `month`= "apr";
UPDATE marketing_targets_staging2 SET `month` = '5' WHERE `month`= "may";
UPDATE marketing_targets_staging2 SET `month` = '6' WHERE `month`= "jun";
UPDATE marketing_targets_staging2 SET `month` = '7' WHERE `month`= "jul";
UPDATE marketing_targets_staging2 SET `month` = '8' WHERE `month`= "aug";
UPDATE marketing_targets_staging2 SET `month` = '9' WHERE `month`= "sep";
UPDATE marketing_targets_staging2 SET `month` = '10' WHERE `month`= "oct";
UPDATE marketing_targets_staging2 SET `month` = '11' WHERE `month`= "mov";
UPDATE marketing_targets_staging2 SET `month` = '12' WHERE `month`= "dec"; 

SELECT `day`, `month`, `year`,
CONCAT(`day`,'/', `month`, '/',`year`) AS concat
FROM marketing_targets_staging2 ;

SELECT * 
FROM marketing_targets_staging2;

ALTER TABLE marketing_targets_staging2 ADD COLUMN full_date VARCHAR(10);

UPDATE marketing_targets_staging2
SET full_date = CONCAT(year, '-', LPAD(month, 2, '0'), '-', LPAD(day, 2, '0'));

ALTER TABLE marketing_targets_staging2 
MODIFY COLUMN full_date DATE;

-- 3. Remove any columns 

ALTER TABLE marketing_targets_staging2 drop COLUMN `day`;
ALTER TABLE marketing_targets_staging2 drop COLUMN `month`;
ALTER TABLE marketing_targets_staging2 drop COLUMN `year`;
