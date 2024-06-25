
-- Banking Data Exploration 

-- Skills Used : CTE's, Windows Functions, Aggregate Functions, Substrings

SELECT * 
FROM marketing_targets_staging2; 

-- Average age per outcome of previous Marketing campaign 
SELECT poutcome, AVG(age) 
FROM marketing_targets_staging2
GROUP BY poutcome;

-- Sum of campaigns by month 
SELECT SUBSTRING(`full_date`,6,2) AS `MONTH`, SUM(campaign)
FROM marketing_targets_staging2
GROUP BY SUBSTRING(`full_date`,6,2);

-- Sum of campaigns by month with year
SELECT SUBSTRING(`full_date`,1,7) AS `MONTH & YEAR`, SUM(campaign)
FROM marketing_targets_staging2
GROUP BY `MONTH & YEAR`
ORDER BY 1 ASC;

-- Rolling total of the number of campaigns by month with year 

WITH Rolling_Total AS
(
SELECT SUBSTRING(`full_date`,1,7) AS `MONTH & YEAR`, SUM(campaign) AS total_campaign 
FROM marketing_targets_staging2
WHERE SUBSTRING(`full_date`,1,7) IS NOT NULL
GROUP BY `MONTH & YEAR`
ORDER BY 1 ASC
)
SELECT `MONTH & YEAR`,total_campaign,
 SUM(total_campaign) OVER(ORDER BY `MONTH & YEAR`) AS Rolling_Total
FROM Rolling_Total ;

-- Total campaigns by year and job 
SELECT job , YEAR(full_date), SUM(campaign)
FROM marketing_targets_staging2
GROUP BY job , YEAR(full_date)
ORDER BY 3 DESC ; 

-- Rank of top 5 jobs and with the highest number of campaigns by year 
WITH job_year (job, years, total_campaigns) AS 
(
SELECT job , YEAR(full_date), SUM(campaign)
FROM marketing_targets_staging2
WHERE job IS NOT NULL
GROUP BY job , YEAR(full_date)
), job_year_rank AS
(SELECT * , 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_campaigns DESC) AS ranking 
FROM job_year
WHERE job IS NOT NULL 
)
SELECT * 
FROM job_year_rank
WHERE ranking <= 5
;

-- Greatest balance and number of campaigns  
SELECT MAX(balance), max(campaign) 
FROM marketing_targets_staging2;


-- Only high campaign numbers 
SELECT * 
FROM marketing_targets_staging2 
WHERE campaign >45; 

-- Only sucessful campaigns 
SELECT *
FROM marketing_targets_staging2 
WHERE poutcome = "success"
ORDER BY campaign DESC; 

-- Only term deposit subscriptions 
SELECT *
FROM marketing_targets_staging2 
WHERE `y` = "yes"
ORDER BY campaign DESC; 

-- Sum of the number of campaings by outcome of campaigns 
SELECT poutcome, SUM(campaign)
FROM marketing_targets_staging2 
GROUP BY poutcome
ORDER BY 2 DESC; 

-- Date rage of campaigns 
SELECT MIN(full_date), MAX(full_date)
FROM marketing_targets_staging2;


-- Campaign outcome and the sum of the campaign durations
SELECT poutcome, SUM(duration)
FROM marketing_targets_staging2 
GROUP BY poutcome
ORDER BY 2 DESC; 

-- Age and campaign outcome
SELECT poutcome ,age
FROM marketing_targets_staging2 
ORDER BY 2 ASC; 


