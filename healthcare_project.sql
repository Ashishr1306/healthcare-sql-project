CREATE DATABASE healthcare_db;
USE healthcare_db;
CREATE TABLE patients (
    patient_id INT,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE doctors (
    doctor_id INT,
    name VARCHAR(100),
    specialization VARCHAR(100)
);

CREATE TABLE appointments (
    appointment_id INT,
    patient_id INT,
    doctor_id INT,
    date DATE
);



-- 1. All patients
SELECT * FROM patients;

-- 2. All doctors
SELECT * FROM doctors;

SELECT * FROM appointments;
SELECT * FROM treatments;
SELECT * FROM sql_queries;

-- 3. Total patients count
SELECT COUNT(*) AS total_patients FROM patients;

-- 4. Total doctors count
SELECT COUNT(*) AS total_doctors FROM doctors;

-- 5. Patient + Doctor + Appointment details
SELECT p.name AS patient, d.name AS doctor, a.appointment_date
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;

-- 6. Treatment details with patient name
SELECT p.name, t.disease, t.cost
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
JOIN patients p ON a.patient_id = p.patient_id;

-- 7. Doctor-wise patients
SELECT d.name AS doctor, p.name AS patient
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN patients p ON a.patient_id = p.patient_id;

-- 8. Total revenue (treatment cost)
SELECT SUM(cost) AS total_revenue FROM treatments;

-- 9. Average treatment cost
SELECT AVG(cost) AS avg_cost FROM treatments;

-- 10. Doctor-wise total earnings
SELECT d.name, SUM(t.cost) AS total_earning
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.name;

-- 11. Disease-wise cases count
SELECT disease, COUNT(*) AS total_cases
FROM treatments
GROUP BY disease
ORDER BY total_cases DESC;

-- 12. Most visited doctor
SELECT d.name, COUNT(a.appointment_id) AS total_visits
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.name
ORDER BY total_visits DESC
LIMIT 1;

-- 13. Highest paying patient
SELECT p.name, SUM(t.cost) AS total_spent
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY p.name
ORDER BY total_spent DESC
LIMIT 1;

-- 14. Patients with no appointments
SELECT * FROM patients
WHERE patient_id NOT IN (
    SELECT patient_id FROM appointments
);

-- 15. Monthly appointments count
SELECT MONTH(appointment_date) AS month, COUNT(*) AS total_appointments
FROM appointments
GROUP BY MONTH(appointment_date);

-- 16. Top 3 costly treatments
SELECT disease, cost
FROM treatments
ORDER BY cost DESC
LIMIT 3;

-- 17. Rank doctors by earnings
SELECT d.name,
       SUM(t.cost) AS total_earning,
       RANK() OVER (ORDER BY SUM(t.cost) DESC) AS ranking
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.name;

-- 18. Running total revenue
SELECT a.appointment_date,
       SUM(t.cost) OVER (ORDER BY a.appointment_date) AS running_total
FROM treatments t
JOIN appointments a 
ON t.appointment_id = a.appointment_id;

-- 19. Repeat patients (visited more than once)
SELECT p.name, COUNT(a.appointment_id) AS visits
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.name
HAVING visits > 1;

-- 20. Most common disease
SELECT disease, COUNT(*) AS freq
FROM treatments
GROUP BY disease
ORDER BY freq DESC
LIMIT 1;

ALTER TABLE appointments
MODIFY appointment_date DATE;

-- 21. List all appointments with status
SELECT appointment_id, appointment_date, status
FROM appointments;

-- 22. Find all patients above age 40
SELECT name, age, gender
FROM patients
WHERE age > 40;


-- 23. List doctors by specialization
SELECT name, specialization
FROM doctors
ORDER BY specialization;

-- 24. Count total appointments by status
SELECT status, COUNT(*) AS total
FROM appointments
GROUP BY status;

-- 25. Find treatments costing more than 5000
SELECT disease, cost
FROM treatments
WHERE cost > 5000
ORDER BY cost DESC;
