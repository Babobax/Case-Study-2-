# Case-Study-2 Covid in Mexico
## About: 

This project is the analysis of over a million Mexican patients who were registered as possible COVID-infected patients in period from 01-2020 to 05-2021.  

Dataset can be found here - https://datos.gob.mx/busca/dataset/informacion-referente-a-casos-covid-19-en-mexico 
                          - https://www.kaggle.com/datasets/meirnizri/covid19-dataset

For this case study I was using PostgreSQL, Python (sqlalchemy and psycopg2 packages to connect with PostgreSQL via Jupyter Notebooks) and Tableau.

## Contents:
- case_study_2_processing.sql - contains more info about the dataset itself and operations done to clean and process it.
- case_study_2_analysis.ipynb - exploratory analysis in form of a report in Jupyter Notebooks (data visualizations are on Tableau Public - via link below). 

Both files are documented with comments and descriptions to guide anyone through the data cleaning and analysis.

Interactive dashboard can be found here - https://public.tableau.com/app/profile/matt.l2298/viz/Covidcs2/Dashboard1


## Data details:
This dataset contains an enormous number of anonymized patient-related information including pre-conditions. The raw dataset consists of 21 unique features and 1,048,576 unique patients. In the Boolean features, 1 means "yes" and 2 means "no". values as 97 and 99 are missing data.

**Sex**: 1 for female and 2 for male. <br>
**Age**: of the patient. <br>
**Classification**: covid test findings. Values 1-3 mean that the patient was diagnosed with covid in different degrees - 4 or higher means that the patient is not a carrier of covid or that the test is inconclusive. <br>
**Patient type**: type of care the patient received in the unit. 1 for returned home and 2 for hospitalization. <br>
**Pneumonia**: whether the patient already have air sacs inflammation or not.<br>
**Pregnancy**: whether the patient is pregnant or not.<br>
**Diabetes**: whether the patient has diabetes or not.<br>
**Copd**: Indicates whether the patient has Chronic Obstructive Pulmonary Disease or not.<br>
**Asthma**: whether the patient has asthma or not.<br>
**Inmsupr**: whether the patient is immunosuppressed or not.<br>
**Hypertension**: whether the patient has hypertension or not.<br>
**Cardiovascular**: whether the patient has heart or blood vessels related disease.<br>
**Renal chronic**: whether the patient has chronic renal disease or not.<br>
**Other disease**: whether the patient has other disease or not.<br>
**Obesity**: whether the patient is obese or not.<br>
**Tobacco**: whether the patient is a tobacco user.<br>
**Usmr**: Indicates whether the patient treated medical units of the first, second or third level.<br>
**Medical unit**: type of institution of the National Health System that provided the care.<br>
**Intubed**: whether the patient was connected to the ventilator.<br>
**Icu**: Indicates whether the patient had been admitted to an Intensive Care Unit.<br>
**Date died**: If the patient died indicate the date of death, and 9999-99-99 otherwise. 
