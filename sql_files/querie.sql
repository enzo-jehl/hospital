-- Select the appointments of a specific patient :
SELECT appointment.appointment_ID, appointment.appointment_date, appointment.patient_ID,
       doctor.doctor_ID, doctor.name, doctor.speciality, doctor.email
FROM appointment
JOIN doctor ON appointment.doctor_ID = doctor.doctor_ID
WHERE appointment.patient_ID = 1;

-- Select all appointments with patient and doctor details :
SELECT appointment.*, patient.name, patient.contact_number, patient.address,
doctor.name, doctor.speciality, doctor.email FROM appointment
JOIN patient ON appointment.patient_ID = patient.patient_ID
JOIN doctor ON appointment.doctor_ID = doctor.doctor_ID;

-- select the patient name, the admission date and the diagnosis for all medical records
SELECT patient.name, medical_record.admission_date, medical_record.diagnosis FROM medical_record
JOIN patient ON medical_record.patient_ID = patient.patient_ID;

-- select the patient name, the doctor name and the appointment date for all appointments.
SELECT patient.name, doctor.name, appointment.appointment_date FROM appointment
JOIN patient ON appointment.patient_ID = patient.patient_ID
JOIN doctor ON appointment.doctor_ID = doctor.doctor_ID;

-- select the department name and the doctor name for all doctors and their department
SELECT doctor.name, department.department_name FROM doctor
JOIN department ON doctor.speciality = department.department_name;

-- select the patient name, the appointment date and the address for all scheduled appointments
SELECT patient.name, appointment.appointment_date, patient.address
FROM appointment
JOIN patient ON appointment.patient_ID = patient.patient_ID
WHERE appointment.appointment_status = 'Scheduled';

-- select all appointments per department with the name of the doctor and the patient
SELECT d.department_name, a.appointment_ID, a.appointment_date, a.appointment_time, doc.name AS doctor_name, p.name AS patient_name
FROM department d
JOIN doctor doc ON d.department_ID = doc.department_ID
JOIN appointment a ON doc.doctor_ID = a.doctor_ID
JOIN patient p ON a.patient_ID = p.patient_ID;

-- select the medical record with a patient name 
SELECT medical_record.*, patient.name AS patient_name
FROM medical_record
JOIN patient ON medical_record.patient_ID = patient.patient_ID;
where patient.name = 'Alexiane Laroye';

-- select the name of the patient, the admission date and the diagnosis for a specific diagnosis
SELECT patient.name, medical_record.admission_date, medical_record.diagnosis
FROM patient
JOIN medical_record ON patient.patient_ID = medical_record.patient_ID
WHERE medical_record.diagnosis = 'Hypertension';

-- select the patient name, the doctor name and the appointment date for a specific patient
SELECT patient.name AS patient_name, doctor.name AS doctor_name, appointment.appointment_date
FROM appointment
JOIN patient ON appointment.patient_ID = patient.patient_ID
JOIN doctor ON appointment.doctor_ID = doctor.doctor_ID
WHERE patient.name = 'Flavien Geoffray';

-- display all patients with their appointmens and the doctor data :
SELECT p.patient_ID, p.name AS patient_name, p.gender, p.date_of_birth, p.contact_number, p.address, a.appointment_ID, a.appointment_date, a.appointment_time, a.appointment_status,
d.doctor_ID, d.name AS doctor_name, d.speciality, d.contact_number AS doctor_contact
FROM patient p
JOIN appointment a ON p.patient_ID = a.patient_ID
JOIN doctor d ON a.doctor_ID = d.doctor_ID;

-- select the number of patients per department, by decreasing order :
SELECT department_name, COUNT(*) AS patient_count
FROM patient
INNER JOIN department ON patient.contacted_department = department.department_name
GROUP BY department_name
ORDER BY patient_count DESC;

-- select the number of patients assigned foreach nurse, by decreasing order
SELECT n.name, COUNT(*) AS patient_count
FROM nurse n
INNER JOIN patient p ON n.nurse_ID = p.nurse_ID
GROUP BY n.name
ORDER BY patient_count DESC;

-- select the date, the number of appointments foreach date, by decreasing order
SELECT appointment_date, COUNT(*) AS appointment_count
FROM appointment
GROUP BY appointment_date
ORDER BY appointment_date;

-- select the number of appointments foreach patient, by decreasing order
SELECT p.patient_ID, p.name, COUNT(*) AS appointment_count
FROM patient p
INNER JOIN appointment a ON p.patient_ID = a.patient_ID
GROUP BY p.patient_ID, p.name
ORDER BY appointment_count DESC;

-- select the number of appointments foreach doctors by decreasing order. display the name of the patient
SELECT d.name AS doctor_name, p.name AS patient_name, COUNT(a.appointment_ID) AS total_appointments
FROM doctor d
JOIN appointment a ON d.doctor_ID = a.doctor_ID
JOIN patient p ON a.patient_ID = p.patient_ID
GROUP BY d.doctor_ID, d.name, p.patient_ID, p.name
ORDER BY total_appointments ASC;

-- select patients with maximum 3 appointments et display their name and the number of appointments and the doctor name
SELECT p.name AS patient_name, COUNT(*) AS appointment_count, d.name AS doctor_name
FROM patient p
INNER JOIN appointment a ON p.patient_ID = a.patient_ID
INNER JOIN doctor d ON a.doctor_ID = d.doctor_ID
GROUP BY p.patient_ID, p.name, d.name
HAVING COUNT(*) < 3;

-- select patients and doctors who have a scheduled appointment for a specific date, by alphabetic order of the patient name
SELECT p.name AS patient_name, d.name AS doctor_name
FROM patient p
INNER JOIN appointment a ON p.patient_ID = a.patient_ID
INNER JOIN doctor d ON a.doctor_ID = d.doctor_ID
WHERE a.appointment_date = '2023-06-10'
ORDER BY p.name;

-- select patients with scheduled appointments with cardiology specialists, sorted in ascending order of appointment date:
SELECT p.name AS patient_name, a.appointment_date, d.name AS doctor_name
FROM patient p
INNER JOIN appointment a ON p.patient_ID = a.patient_ID
INNER JOIN doctor d ON a.doctor_ID = d.doctor_ID
WHERE d.speciality = 'Cardiology'
ORDER BY a.appointment_date;

-- Select patients with at most 1 appointment and display their name, the name of the doctor who treated them, and in which department:
SELECT p.name AS patient_name, d.name AS doctor_name, dep.department_name
FROM patient p
LEFT JOIN appointment a ON p.patient_ID = a.patient_ID
LEFT JOIN doctor d ON a.doctor_ID = d.doctor_ID
LEFT JOIN department dep ON d.department_ID = dep.department_ID
GROUP BY p.patient_ID, p.name, d.name, dep.department_name
HAVING COUNT(a.appointment_ID) <= 1;


