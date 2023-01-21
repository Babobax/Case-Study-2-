SELECT *
FROM valid_covid_19_data
LIMIT 100

-- The copied table works as intended, so now we may proceed to querying the database for some insights.
-- I'm going to query the dataset in some ways. I'm going to create a single dashboard, so not all the queries will be visualized.


-- Number of all patients
SELECT COUNT(*) all_patients
FROM valid_covid_19_data

-- Period covered in the dataset (starting date, ending date, and amount of days between them)
SELECT MIN(date_died) starting_date, 
		MAX(date_died) ending_date, 
		MAX(date_died) - MIN(date_died) days_span
FROM valid_covid_19_data


-- Sex distribution
SELECT sex, COUNT(sex)
FROM valid_covid_19_data
GROUP BY sex

-- Count of all patients, deaths, and death rate.                           
SELECT COUNT(*) patients, 
		COUNT(date_died) deaths, 
		CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(*)::numeric, 2) || '%') death_rate
FROM valid_covid_19_data

-- Deaths percentage for males/females, with total patients number and total deaths number divided by sex
SELECT sex, 
		COUNT(*) all_patients,
		COUNT(date_died) total_deaths,  
		CONCAT(ROUND(100 * COUNT(date_died) / COUNT(*)::numeric,2) || '%') as death_rate
FROM valid_covid_19_data
GROUP BY sex

-- Intubation rate
SELECT COUNT(*) all_patients, 
		COUNT(intubed) intubed_patients, 
		CONCAT(ROUND(COUNT(intubed) * 100 / COUNT(*)::numeric, 2) || '%') intubation_rate
FROM valid_covid_19_data
-- Data shows, that almost 20% of patients had respiratory problems when dealing with COVID.

-- COVID test results
SELECT classification_final test_result, COUNT(classification_final) patients
FROM valid_covid_19_data
GROUP BY classification_final
ORDER BY patients DESC

-- Deaths per month
SELECT TO_CHAR(date_died, 'MM-YYYY') months, COUNT(date_died) deaths_per_month
FROM valid_covid_19_data
WHERE date_died IS NOT NULL
GROUP BY months
ORDER BY months

-- Deaths per day
SELECT date_died, COUNT(date_died) as deaths_per_day
FROM valid_covid_19_data
WHERE date_died IS NOT NULL
GROUP BY date_died


-- Count of all patients carrying a certain disease with count of how many of these carriers died (2nd count automatically 	  throws out null values, giving the accurate deaths number) and average age of the deceased patients, according to the      disease.
SELECT 'Pneumonia' disease, COUNT(pneumonia) patients, COUNT(pneumonia) - COUNT(date_died) alive, 
		COUNT(date_died) deceased, CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(pneumonia)::numeric, 2) || '%') death_rate, 		   ROUND(AVG(age),2) avg_age
FROM valid_covid_19_data
WHERE pneumonia = true
GROUP BY pneumonia
UNION 
SELECT 'Obesity', COUNT(obesity), COUNT(obesity) - COUNT(date_died), 
		COUNT(date_died), CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(obesity)::numeric, 2) || '%'), 
		ROUND(AVG(age),2)
FROM valid_covid_19_data
WHERE obesity = true
GROUP BY obesity
UNION
SELECT 'Diabetes', COUNT(diabetes), COUNT(diabetes) - COUNT(date_died), 
		COUNT(date_died), CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(diabetes)::numeric, 2) || '%'), 
		ROUND(AVG(age),2)
FROM valid_covid_19_data
WHERE diabetes = true
GROUP BY diabetes
UNION
SELECT 'COPD', COUNT(copd), COUNT(copd) - COUNT(date_died), 
		COUNT(date_died), CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(copd)::numeric, 2) || '%'), 
		ROUND(AVG(age),2)
FROM valid_covid_19_data
WHERE copd = true
GROUP BY copd
UNION
SELECT 'Asthma', COUNT(asthma), COUNT(asthma) - COUNT(date_died), 
		COUNT(date_died), CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(asthma)::numeric, 2) || '%'), 
		ROUND(AVG(age),2)
FROM valid_covid_19_data
WHERE asthma = true
GROUP BY asthma
UNION
SELECT 'Immunosuppression', COUNT(immunosuppression), COUNT(immunosuppression) - COUNT(date_died), 
		COUNT(date_died), CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(immunosuppression)::numeric, 2) || '%'), 					ROUND(AVG(age),2)
FROM valid_covid_19_data
WHERE immunosuppression = true
GROUP BY immunosuppression
UNION
SELECT 'Hypertension', COUNT(hypertension), COUNT(hypertension) - COUNT(date_died), 
		COUNT(date_died), CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(hypertension)::numeric, 2) || '%'), 
		ROUND(AVG(age),2)
FROM valid_covid_19_data
WHERE hypertension = true
GROUP BY hypertension
UNION
SELECT 'Cardiovascular', COUNT(cardiovascular), COUNT(cardiovascular) - COUNT(date_died), 
		COUNT(date_died), CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(cardiovascular)::numeric, 2) || '%'), 					ROUND(AVG(age),2)
FROM valid_covid_19_data
WHERE cardiovascular = true
GROUP BY cardiovascular
UNION
SELECT 'Renal Chronic', COUNT(renal_chronic), COUNT(renal_chronic) - COUNT(date_died), 
		COUNT(date_died), CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(renal_chronic)::numeric, 2) || '%'), 						ROUND(AVG(age),2)
FROM valid_covid_19_data
WHERE renal_chronic = true
GROUP BY renal_chronic
/* Data tells us, that over 1/3 of patients who had pneumonia eventually had passed, the number is extremely high. Pneumonia appears to be significantly more dangerous combined with COVID-19 than other diseases. 

The average age for deceased patients who had pneumonia is 53.81 yrs old. I've checked in case it's tied to old age of these patients, but slightly less than 54 years
*/

-- Tobacco users by sex
SELECT sex, COUNT(*) tobacco_users, 
		(SELECT COUNT(*)
		FROM valid_covid_19_data) total
FROM valid_covid_19_data
WHERE tobacco = TRUE
GROUP BY sex
-- Count of positive/negative test results by age.
SELECT age, classification_final, COUNT(classification_final) results
FROM valid_covid_19_data
GROUP BY age, classification_final
ORDER BY age

-- Min max and average age for people with confirmed COVID and those without divided by sex
SELECT 'COVID', sex, MIN(age) minimum_age, MAX(age) maximum_age, ROUND(AVG(age),2) average_age
FROM valid_covid_19_data
WHERE classification_final = 'COVID'
GROUP BY sex
UNION
SELECT 'Inconclusive/not a carrier', sex, MIN(age) minimum_age, MAX(age) maximum_age, ROUND(AVG(age),2) average_age
FROM valid_covid_19_data
WHERE classification_final = 'Inconclusive/not a carrier'
GROUP BY sex
ORDER BY sex

-- Stationed&deceased patients per med unit ordered by total patients descending (rounded up percentages)
SELECT medical_unit, 
		COUNT(date_died) deceased, 
		COUNT(*) patients_per_med_unit, 
		CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(*)::numeric, 2) || '%') deceased_percentage
FROM valid_covid_19_data 
GROUP BY medical_unit
ORDER BY patients_per_med_unit DESC

-- Deaths per medical unit
SELECT medical_unit, COUNT(date_died) deceased
FROM valid_covid_19_data 
WHERE date_died IS NOT NULL
GROUP BY medical_unit

-- How were people taken care of and if they died (rounded up percentages)
SELECT care_received, 
		COUNT(care_received) people, 
		COUNT(date_died) deaths, 
		CONCAT(ROUND(COUNT(date_died) * 100 / COUNT(care_received)::numeric, 2) || '%')				
FROM valid_covid_19_data
GROUP BY care_received

-- Deaths by age, ordered by the most deathful groups
SELECT ROUND(AVG(age),0) age, COUNT(date_died) deaths, sex
FROM valid_covid_19_data
WHERE date_died IS NOT NULL
GROUP BY age, sex
-- HAVING age < 60 -- used to filter the age groups (if needed)
ORDER BY deaths DESC
-- the 31st age-group is the first one consisting of females. Considering the majority (small one though) of the examined patients were females, it's extremely alarming for males.

-- Count of deaths and survivors of those who had an ICU intervention
SELECT 'Dead after ICU intervention' outcome, COUNT(icu)
FROM valid_covid_19_data
WHERE icu = TRUE and date_died IS NOT NULL
UNION
SELECT 'Alive after ICU intervention', COUNT(icu)
FROM valid_covid_19_data
WHERE icu = TRUE and date_died IS NULL

-- Peak deaths on one day
SELECT date_died, COUNT(date_died)
FROM valid_covid_19_data
GROUP BY date_died
ORDER BY COUNT(date_died) DESC
LIMIT 1

-- Days with least deceased patients, ordered by number of deceased patients and then sorted chronologically
SELECT date_died, COUNT(date_died)
FROM valid_covid_19_data
WHERE date_died IS NOT NULL 
GROUP BY date_died
HAVING COUNT(date_died) <= 1
ORDER BY COUNT(date_died), date_died ASC
-- We can see that between 2020-01-04 and 2020-09-06 there wasn't a day where only one person died of COVID/related diseases, that's a very long time. Of course in that period COVID became a pandemic.

-- Checking how many pregnant women survived/died of COVID.
SELECT 'Deceased pregnant women' pregnant_covid, COUNT(*) patients
FROM valid_covid_19_data
WHERE pregnant = TRUE and date_died IS NOT NULL
UNION
SELECT 'Alive pregnant women', COUNT(*)
FROM valid_covid_19_data
WHERE pregnant = TRUE and date_died IS NULL


