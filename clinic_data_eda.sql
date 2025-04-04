-- Exploratory Data Analysis on clinic data 

SELECT * 
FROM mis602_ass2.appointment;

SELECT COUNT((appointment_id))
FROM mis602_ass2.appointment;
-- total number of patients, each doctor is treating

SELECT  doctor_id, COUNT(DISTINCT(patient_id)) AS total_patients
FROM mis602_ass2.appointment
GROUP BY doctor_id
;
-- first 80 patients got the appointment and treatment from appointment table so now we check the demographic details and gender details

SELECT * 
FROM mis602_ass2.patient
WHERE patient_id <= 80
ORDER BY patient_id ASC;

-- 

SELECT gender, COUNT(DISTINCT(patient_id)) AS patients
FROM mis602_ass2.patient
WHERE patient_id <= 80
GROUP BY gender
;

WITH Patient_CTE AS
(SELECT * 
FROM mis602_ass2.patient
WHERE patient_id <= 80
ORDER BY patient_id ASC)
SELECT COUNT(DISTINCT(patient_id)) as no_of_patients, state_code
FROM Patient_CTE
GROUP BY state_code
ORDER BY 1;

-- Now finding the health trends

SELECT *
FROM mis602_ass2.prescription
GROUP BY prescription_id
ORDER BY prescription_id;

SELECT COUNT(DISTINCT(appointment_id))
FROM mis602_ass2.prescription;

SELECT appointment_id, COUNT(prescription_id) AS no_of_prescription
FROM mis602_ass2.prescription
GROUP BY appointment_id
;

SELECT *
FROM  mis602_ass2.prescription pres
JOIN mis602_ass2.medication med
	ON pres.medication_id=med.medication_id
;

-- here we found that only 12 patients got prescriptions, each one got 3 prescriptions and most of the prescriptions are related to anti axienty or pain reliever.


SELECT COUNT(appointment_id) AS no_of_appointments, notes
FROM mis602_ass2.appointment
GROUP BY notes;




SELECT *
FROM  mis602_ass2.prescription pres
JOIN mis602_ass2.appointment app
ON app.appointment_id= pres.appointment_id
JOIN mis602_ass2.doctor doc
ON app.doctor_id= doc.doctor_id
JOIN mis602_ass2.patient pat
    ON app.patient_id = pat.patient_id
;



SELECT doc.name AS doctor_name, pat.name AS patient_name, app.appointment_id, prescription_id
FROM  mis602_ass2.prescription pres
JOIN mis602_ass2.appointment app
ON app.appointment_id= pres.appointment_id
JOIN mis602_ass2.doctor doc
ON app.doctor_id= doc.doctor_id
JOIN mis602_ass2.patient pat
    ON app.patient_id = pat.patient_id
;

SELECT 
  doc.name AS doctor_name,
  COUNT(pres.prescription_id) AS total_prescriptions
FROM mis602_ass2.prescription pres
JOIN mis602_ass2.appointment app
  ON app.appointment_id = pres.appointment_id
JOIN mis602_ass2.doctor doc
  ON app.doctor_id = doc.doctor_id
GROUP BY doc.name
ORDER BY total_prescriptions DESC;

-- Total doctors who give prescriptions are 11 and Dr. John Doe has given 6 prescriptions to two patients so each one is give 3 prescriptions to each patient 

SELECT doc.name, pat.name, notes, med.name, description
FROM mis602_ass2.prescription pres
JOIN mis602_ass2.appointment app
  ON app.appointment_id = pres.appointment_id
JOIN mis602_ass2.doctor doc
  ON app.doctor_id = doc.doctor_id
JOIN mis602_ass2.patient pat
    ON app.patient_id = pat.patient_id
    JOIN mis602_ass2.medication med
    ON   pres.medication_id = med.medication_id
;

-- here we found about  doctors who prescribed particular patients and patient prescriptions and their medical notes 



-- no of patients in each state

SELECT state_code, COUNT(DISTINCT(patient_id)) AS num_of_patients

FROM mis602_ass2.patient
GROUP BY state_code;


SELECT  state_code, COUNT(DISTINCT(doc.doctor_id)) AS no_of_doctors
FROM mis602_ass2.appointment app
JOIN mis602_ass2.doctor doc
  ON app.doctor_id = doc.doctor_id
JOIN mis602_ass2.patient pat
    ON app.patient_id = pat.patient_id
GROUP BY state_code
ORDER BY 2 DESC
;
-- Here we found that NSW state has the most doctors, 17 and TAS has lowest value as 6. We can find out which state needs more doctors 

SELECT count(DISTINCT(state_code))
FROM mis602_ass2.patient
;

WITH No_Appointment AS(
SELECT *
FROM mis602_ass2.patient
WHERE patient_id >= 80
ORDER BY patient_id ASC
)
SELECT state_code, COUNT(patient_id)
FROM No_Appointment
 GROUP BY state_code;

-- Each 6 states has 4 patients, which did not get the appointment, now check time series pattern
-- and male and female got the treatment equally
SELECT  gender, COUNT(DISTINCT(patient_id)) AS num_of_patients
FROM mis602_ass2.patient
GROUP BY gender;

-- finding more  about prescribed medicines
SELECT name, dosage_form, strength, description
FROM mis602_ass2.medication
WHERE description LIKE 'pain%' OR description  LIKE 'Antibiotic%'
;
 
 
 SELECT name, dosage_form, strength, description
FROM mis602_ass2.medication
WHERE description LIKE 'Antidep%'
;

SELECT name, COUNT(*) AS times_prescribed
FROM mis602_ass2.medication
GROUP BY name
HAVING COUNT(*)>1
 ;
-- medicines which are prescribed more than once. 
 
-- now checking the schedule patterns of appointments , as we know total period of time is 7 months and 10 days from 10th may to 20 dec, 2023

SELECT *
FROM mis602_ass2.appointment
ORDER BY 4;

SELECT doc.name, pat.name,dob,appointment_date
FROM mis602_ass2.appointment app
JOIN mis602_ass2.doctor doc
  ON app.doctor_id = doc.doctor_id
JOIN mis602_ass2.patient pat
    ON app.patient_id = pat.patient_id
ORDER BY appointment_date
;
-- total number of appointments in one day, week and month
SELECT 
appointment_date,
COUNT(*) AS total_appointments
FROM mis602_ass2.appointment
GROUP BY appointment_date
ORDER BY appointment_date;

SELECT 
  DAYNAME(appointment_date) AS weekday,
  COUNT(*) AS total_appointments
FROM mis602_ass2.appointment
GROUP BY weekday
ORDER BY total_appointments DESC;


SELECT 
  DATE_FORMAT(appointment_date, '%Y-%m') AS month,
  COUNT(*) AS total_appointments
FROM mis602_ass2.appointment
GROUP BY month
ORDER BY month;


-- doctors with more appointments

SELECT 
  doc.name AS doctor_name,
  COUNT(*) AS total_appointments
FROM mis602_ass2.appointment app
JOIN mis602_ass2.doctor doc ON app.doctor_id = doc.doctor_id
GROUP BY doctor_name
ORDER BY total_appointments DESC;

-- patients with age getting the appointments
SELECT 
  CASE 
    WHEN TIMESTAMPDIFF(YEAR, pat.dob, CURDATE()) < 18 THEN 'Under 18'
    WHEN TIMESTAMPDIFF(YEAR, pat.dob, CURDATE()) BETWEEN 18 AND 35 THEN '18-35'
    WHEN TIMESTAMPDIFF(YEAR, pat.dob, CURDATE()) BETWEEN 36 AND 60 THEN '36-60'
    ELSE '60+' 
  END AS age_group,
  COUNT(*) AS total_appointments
FROM mis602_ass2.appointment app
JOIN mis602_ass2.patient pat ON app.patient_id = pat.patient_id
GROUP BY age_group
ORDER BY total_appointments DESC;

-- patients with more visits
SELECT 
  patient_id,
  COUNT(*) AS visit_count
FROM mis602_ass2.appointment
GROUP BY patient_id
HAVING visit_count > 1
ORDER BY visit_count DESC;


-- age of patients with more visits

WITH RepeatedVisitors AS (
  SELECT 
    patient_id,
    COUNT(*) AS visit_count
  FROM mis602_ass2.appointment
  GROUP BY patient_id
  HAVING visit_count >= 2
)

SELECT 
  pat.patient_id,
  pat.name AS patient_name,
  pat.dob,
  TIMESTAMPDIFF(YEAR, pat.dob, CURDATE()) AS age,
  rv.visit_count
FROM RepeatedVisitors rv
JOIN mis602_ass2.patient pat
  ON rv.patient_id = pat.patient_id
ORDER BY age DESC;


-- which age group has which medication_type
 
 WITH PatientAge AS (
  SELECT 
    patient_id,
    TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age,
    CASE 
      WHEN TIMESTAMPDIFF(YEAR, dob, CURDATE()) < 18 THEN 'Under 18'
      WHEN TIMESTAMPDIFF(YEAR, dob, CURDATE()) BETWEEN 18 AND 35 THEN '18-35'
      WHEN TIMESTAMPDIFF(YEAR, dob, CURDATE()) BETWEEN 36 AND 60 THEN '36-60'
      ELSE '60+'
    END AS age_group
  FROM mis602_ass2.patient
),

PrescribedMedications AS (
  SELECT 
    pa.age_group,
    med.description AS medication_description
  FROM mis602_ass2.prescription pres
  JOIN mis602_ass2.appointment app ON pres.appointment_id = app.appointment_id
  JOIN PatientAge pa ON app.patient_id = pa.patient_id
  JOIN mis602_ass2.medication med ON pres.medication_id = med.medication_id
)

SELECT 
  age_group,
  medication_description,
  COUNT(*) AS times_prescribed
FROM PrescribedMedications
GROUP BY age_group, medication_description
ORDER BY age_group, times_prescribed DESC;
 

