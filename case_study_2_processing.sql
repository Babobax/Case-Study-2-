-- Info from the creator of the dataset - "Contains a vast number of anonymized patient-related information including pre-conditions. The raw dataset consists of 21 different features and 1,048,576 unique patients. In the Boolean features, 1 means "yes" and 2 means "no". values as 97 and 99 are missing data." Whole dataset can be found on Kaggle - https://www.kaggle.com/datasets/meirnizri/covid19-dataset

/* 
Variables in depth:

- usmr: Indicates whether the patient treated medical units of the first, second or third level.
- medical unit: type of institution of the National Health System that provided the care.
- sex: 1 for female and 2 for male.
- patient type: type of care the patient received in the unit. 1 for returned home and 2 for hospitalization.
- date died: If the patient died indicate the date of death, and 9999-99-99 otherwise.
- intubed: whether the patient was connected to the ventilator.
- pneumonia: whether the patient already have air sacs inflammation or not.
- age: of the patient.
- pregnant: whether the patient is pregnant or not.
- diabetes: whether the patient has diabetes or not.
- copd: Indicates whether the patient has Chronic obstructive pulmonary disease or not.
- asthma: whether the patient has asthma or not.
- inmsupr: whether the patient is immunosuppressed or not.
- hypertension: whether the patient has hypertension or not.
- cardiovascular: whether the patient has heart or blood vessels related disease.
- renal chronic: whether the patient has chronic renal disease or not.
- other disease: whether the patient has other disease or not.
- obesity: whether the patient is obese or not.
- tobacco: whether the patient is a tobacco user.
- classification: covid test findings. Values 1-3 mean that the patient was diagnosed with covid in different
degrees. 4 or higher means that the patient is not a carrier of covid or that the test is inconclusive.
- icu: Indicates whether the patient had been admitted to an Intensive Care Unit.

*/

-- First, I'm going to initiate the table, so I can import the data.

CREATE TABLE covid_19_data (
	usmer INT,
	medical_unit INT,
	sex VARCHAR(1),
	patient_time VARCHAR(50),
	date_died VARCHAR(100),
	intubed VARCHAR(10),
	pneumonia VARCHAR(10),
	age INT,
	pregnant VARCHAR(10),
	diabetes VARCHAR(10),
	copd VARCHAR(10), -- COPD stands for Chronic Obstructive Pulmonary Disease
	asthma VARCHAR(10),
	inmsupr VARCHAR(10),
	hipertension VARCHAR(10),
	other_disease VARCHAR(10),
	cardiovascular VARCHAR(10),
	obesity VARCHAR(10),
	renal_chronic VARCHAR(10),
	tobacco VARCHAR(10),
	classification_final VARCHAR(50),
	icu VARCHAR(10)
)

-- Now importing data from a .csv file through pgAdmin.

-- Checking if the import was successful:
SELECT * FROM covid_19_data

-- First things first, I'll add a column which will contain a primary key, in case I need to specifically distinguish the patients/do some self joins:

ALTER TABLE covid_19_data
ADD COLUMN patient_id SERIAL PRIMARY KEY


/* 
Now I'll update column names and input values, to make it clearer. Dataset unfortunately was not created
in the most optimal way, so here I will be fixing that. 
*/

ALTER TABLE covid_19_data
RENAME COLUMN usmer TO treatment_type

ALTER TABLE covid_19_data
RENAME COLUMN patient_time TO care_received

ALTER TABLE covid_19_data
RENAME COLUMN inmsupr TO immunosuppressed

ALTER TABLE covid_19_data
RENAME COLUMN hipertension TO hypertension

-- Checking again if changes were applied correctly:
SELECT * FROM covid_19_data
LIMIT 100

-- Now that column names are corrected, and are more descriptive and accurate, I can get right into changing data types and values in certain columns. I'm going to change "1 or 2" inputs to bool type, meaning that given cells will give either TRUE or FALSE. To do that, I'm going to reassign '2' values to '0'. The reason is that Postgres autodetects boolean values as 0=FALSE 1=TRUE, and with 1's and 2's data would become invalid. That said, next query is going to be the first step towards processing boolean columns.

UPDATE covid_19_data
SET intubed = REPLACE(intubed, '2', '0'),
pneumonia = REPLACE(pneumonia, '2', '0'),
pregnant = REPLACE(pregnant, '2', '0'),
diabetes = REPLACE(diabetes, '2', '0'),
copd = REPLACE(copd, '2', '0'),
asthma = REPLACE(asthma, '2', '0'),
immunosuppressed = REPLACE(immunosuppressed, '2', '0'),
hypertension = REPLACE(hypertension, '2', '0'),
other_disease = REPLACE(other_disease, '2', '0'),
cardiovascular = REPLACE(cardiovascular, '2', '0'),
obesity = REPLACE(obesity, '2', '0'),
renal_chronic = REPLACE(renal_chronic, '2', '0'),
tobacco = REPLACE(tobacco, '2', '0'),
icu = REPLACE(icu, '2', '0')

-- Some of the "null" values were also typed as 98 (no idea why, they were supposed to be either 97 or 99) so I applied changes to some updates below.

UPDATE covid_19_data
SET intubed = NULL
WHERE intubed IN ('97', '99') 

UPDATE covid_19_data
SET pneumonia = NULL
WHERE pneumonia IN ('97', '99')

UPDATE covid_19_data
SET pregnant = NULL
WHERE pregnant IN ('97', '98', '99')

UPDATE covid_19_data
SET diabetes = NULL
WHERE diabetes IN ('97', '98', '99')

UPDATE covid_19_data
SET copd = NULL
WHERE copd IN ('97', '98', '99')

UPDATE covid_19_data
SET asthma = NULL
WHERE asthma IN ('97','98', '99')

UPDATE covid_19_data
SET immunosuppressed = NULL
WHERE immunosuppressed IN ('97','98','99')

UPDATE covid_19_data
SET hypertension = NULL
WHERE hypertension IN ('97','98','99')

UPDATE covid_19_data
SET other_disease = NULL
WHERE other_disease IN ('97','98','99')

UPDATE covid_19_data
SET cardiovascular = NULL
WHERE cardiovascular IN ('97','98','99')

UPDATE covid_19_data
SET obesity = NULL
WHERE obesity IN ('97','98','99')

UPDATE covid_19_data
SET renal_chronic = NULL
WHERE renal_chronic IN ('97','98','99')

UPDATE covid_19_data
SET tobacco = NULL
WHERE tobacco IN ('97','98','99')
 
UPDATE covid_19_data
SET icu = NULL
WHERE icu IN ('97', '99')

-- And finally, converting 0's and 1's to TRUEs and FALSEs

ALTER TABLE covid_19_data
ALTER COLUMN intubed TYPE BOOL 
USING intubed::boolean

ALTER TABLE covid_19_data
ALTER COLUMN pneumonia TYPE BOOL 
USING pneumonia::boolean

ALTER TABLE covid_19_data
ALTER COLUMN pregnant TYPE BOOL 
USING pregnant::boolean

ALTER TABLE covid_19_data
ALTER COLUMN diabetes TYPE BOOL 
USING diabetes::boolean

ALTER TABLE covid_19_data
ALTER COLUMN copd TYPE BOOL 
USING copd::boolean

ALTER TABLE covid_19_data
ALTER COLUMN asthma TYPE BOOL 
USING asthma::boolean

ALTER TABLE covid_19_data
ALTER COLUMN immunosuppressed TYPE BOOL 
USING immunosuppressed::boolean

ALTER TABLE covid_19_data
ALTER COLUMN hypertension TYPE BOOL 
USING hypertension::boolean

ALTER TABLE covid_19_data
ALTER COLUMN other_disease TYPE BOOL 
USING other_disease::boolean

ALTER TABLE covid_19_data
ALTER COLUMN cardiovascular TYPE BOOL 
USING cardiovascular::boolean

ALTER TABLE covid_19_data
ALTER COLUMN obesity TYPE BOOL 
USING obesity::boolean

ALTER TABLE covid_19_data
ALTER COLUMN renal_chronic TYPE BOOL 
USING renal_chronic::boolean

ALTER TABLE covid_19_data
ALTER COLUMN tobacco TYPE BOOL 
USING tobacco::boolean

ALTER TABLE covid_19_data
ALTER COLUMN icu TYPE BOOL 
USING icu::boolean


SELECT * FROM covid_19_data
LIMIT 100

-- Boolean only columns are fine now, so all that's left is to convert some other values. Let's start with dates

UPDATE covid_19_data
SET date_died = NULL
WHERE date_died = '9999-99-99'

-- And converting the date_died to date data type

ALTER TABLE covid_19_data
ALTER COLUMN date_died TYPE date
USING date_died::date

-- The sex column, to make it clearer what the records mean

UPDATE covid_19_data
SET sex = 'F'
WHERE sex = '1'

UPDATE covid_19_data
SET sex = 'M'
WHERE sex = '2'

-- The care_received column

UPDATE covid_19_data
SET care_received = 'Returned home'
WHERE care_received = '1'

UPDATE covid_19_data
SET care_received = 'Hospitalized'
WHERE care_received = '2'

-- Last, the classification_final column

UPDATE covid_19_data
SET classification_final = 'COVID'
WHERE classification_final IN ('1', '2', '3')

UPDATE covid_19_data
SET classification_final = 'Test inconclusive/not a carrier'
WHERE classification_final IN ('4', '5', '6', '7')


-- Creating copy of a table, which will act as a processed one. The one that I've been working in will act as a open space to apply some new changes in the future (if needed).

CREATE TABLE valid_covid_19_data AS
SELECT * FROM covid_19_data
