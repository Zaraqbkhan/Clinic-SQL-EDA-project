# 📁 Dataset: Clinic Case Study (SQL Database)

**Source**: [Kaggle – Clinic Case Study Dataset](https://www.kaggle.com/datasets/rizwanali324/clinic-case-study-dataset)

This dataset simulates the operations of a fictional clinic using a structured SQL database. It contains information about patients, appointments, doctors, prescriptions, and medications. The dataset is ideal for performing exploratory data analysis using SQL to derive insights into patient care, scheduling trends, and treatment patterns.

---

## 🗂️ Table Structure Overview

### 1. `appointment`
- `appointment_id` (Primary Key)  
- `patient_id` (Foreign Key → `patient`)  
- `doctor_id` (Foreign Key → `doctor`)  
- `appointment_date`  
- `notes` – purpose or remarks for the appointment  
- `status` – e.g., completed, cancelled

### 2. `doctor`
- `doctor_id` (Primary Key)  
- `name`  
- `phone_number`  
- `speciality_id`

### 3. `patient`
- `patient_id` (Primary Key)  
- `name`  
- `dob`  
- `gender`  
- `phone_number`  
- `address`  
- `state_code`

### 4. `medication`
- `medication_id` (Primary Key)  
- `name`  
- `manufacturer`  
- `dosage_form` – e.g., tablet, syrup  
- `strength` – e.g., 500mg  
- `description` – treatment purpose

### 5. `prescription`
- `prescription_id` (Primary Key)  
- `appointment_id` (Foreign Key → `appointment`)  
- `medication_id` (Foreign Key → `medication`)

---

## 🔗 Relationships

- Each **patient** can have multiple **appointments**.
- Each **appointment** is linked to one **doctor** and can result in multiple **prescriptions**.
- **Prescriptions** connect **appointments** with **medications**.
- **Doctors** are connected to appointments and identified by a specialty.

---

## 📝 Notes

This dataset supports use cases such as:
- Analyzing patient demographics
- Exploring medication trends
- Understanding appointment behavior
- Evaluating doctor workload and scheduling patterns
