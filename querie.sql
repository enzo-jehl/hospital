--Sélectionner tous les rendez-vous pour un patient spécifique : 
SELECT appointment.*, doctor.* FROM appointment
JOIN doctor ON appointment.doctor_ID = doctor.doctor_ID
WHERE appointment.patient_ID = 1;

--Sélectionner tous les rendez-vous avec les détails du patient et du médecin :
SELECT appointment.*, patient.*, doctor.* FROM appointment
JOIN patient ON appointment.patient_ID = patient.patient_ID
JOIN doctor ON appointment.doctor_ID = doctor.doctor_ID;

--Sélectionner le nom du patient, la date d'admission et le diagnostic pour tous les dossiers médicaux :
SELECT patient.name, medical_record.admission_date, medical_record.diagnosis FROM medical_record
JOIN patient ON medical_record.patient_ID = patient.patient_ID;

--Sélectionner le nom du patient, le nom du médecin et la date du rendez-vous pour tous les rendez-vous :
SELECT patient.name, doctor.name, appointment.appointment_date FROM appointment
JOIN patient ON appointment.patient_ID = patient.patient_ID
JOIN doctor ON appointment.doctor_ID = doctor.doctor_ID;

--Sélectionner le nom du département et le nom du médecin pour tous les médecins et leurs départements respectifs :
SELECT doctor.name, department.department_name FROM doctor
JOIN department ON doctor.speciality = department.department_name;

--Sélectionner le nom du patient, la date du rendez-vous et l'adresse du patient pour tous les rendez-vous qui ont été programmés :
SELECT patient.name, appointment.appointment_date, patient.address
FROM appointment
JOIN patient ON appointment.patient_ID = patient.patient_ID
WHERE appointment.appointment_status = 'Scheduled';

--Sélectionner tous les rendez-vous avec les détails du patient et du médecin pour les rendez-vous qui ont un patient associé :
SELECT appointment.*, patient.*, doctor.*
FROM appointment
JOIN patient ON appointment.patient_ID = patient.patient_ID
JOIN doctor ON appointment.doctor_ID = doctor.doctor_ID;

--Sélectionner tous les dossiers médicaux avec le nom du patient pour les dossiers médicaux qui ont un patient associé :
SELECT medical_record.*, patient.name AS patient_name
FROM medical_record
JOIN patient ON medical_record.patient_ID = patient.patient_ID;

--Sélectionner le nom du patient, la date d'admission et le diagnostic pour les patients ayant un diagnostic spécifique :
SELECT patient.name, medical_record.admission_date, medical_record.diagnosis
FROM patient
JOIN medical_record ON patient.patient_ID = medical_record.patient_ID
WHERE medical_record.diagnosis = 'Hypertension';

--Sélectionner le nom du patient, le nom du médecin et la date du rendez-vous pour tous les rendez-vous associés à un patient spécifique :
SELECT patient.name AS patient_name, doctor.name AS doctor_name, appointment.appointment_date
FROM appointment
JOIN patient ON appointment.patient_ID = patient.patient_ID
JOIN doctor ON appointment.doctor_ID = doctor.doctor_ID
WHERE patient.name = 'Flavien Geoffray';

--Afficher les patients avec leurs rendez-vous et les informations du médecin correspondant :
SELECT p.patient_ID, p.name AS patient_name, p.gender, p.date_of_birth, p.contact_number, p.address, a.appointment_ID, a.appointment_date, a.appointment_time, a.appointment_status,
d.doctor_ID, d.name AS doctor_name, d.speciality, d.contact_number AS doctor_contact
FROM patient p
JOIN appointment a ON p.patient_ID = a.patient_ID
JOIN doctor d ON a.doctor_ID = d.doctor_ID;

--Sélectionner le nombre de patients par département, trié par ordre décroissant du nombre de patients :
SELECT department_name, COUNT(*) AS patient_count
FROM patient
INNER JOIN department ON patient.contacted_department = department.department_name
GROUP BY department_name
ORDER BY patient_count DESC;

--Sélectionner le nombre de patients assignés à chaque infirmière, trié par ordre décroissant du nombre de patients :
SELECT n.name, COUNT(*) AS patient_count
FROM nurse n
INNER JOIN patient p ON n.nurse_ID = p.nurse_ID
GROUP BY n.name
ORDER BY patient_count DESC;

--Sélectionner la date de rendez-vous, le nombre de rendez-vous prévus pour chaque date, triés par ordre croissant de la date :
SELECT appointment_date, COUNT(*) AS appointment_count
FROM appointment
GROUP BY appointment_date
ORDER BY appointment_date;

--Sélectionner le nombre total de rendez-vous prévus pour chaque patient, trié par ordre décroissant du nombre de rendez-vous :
SELECT p.patient_ID, p.name, COUNT(*) AS appointment_count
FROM patient p
INNER JOIN appointment a ON p.patient_ID = a.patient_ID
GROUP BY p.patient_ID, p.name
ORDER BY appointment_count DESC;

--Sélectionner le nombre total de rendez-vous prévus pour chaque médecin, trié par ordre croissant du nombre de rendez-vous, tout en affichant le nom de leur patient à chaque fois :
SELECT d.name AS doctor_name, p.name AS patient_name, COUNT(a.appointment_ID) AS total_appointments
FROM doctor d
JOIN appointment a ON d.doctor_ID = a.doctor_ID
JOIN patient p ON a.patient_ID = p.patient_ID
GROUP BY d.doctor_ID, d.name, p.patient_ID, p.name
ORDER BY total_appointments ASC;

--Sélectionner les patients ayant au plus 3 rendez-vous et afficher leur nom, le nombre total de rendez-vous et le nom du médecin qui les a traités :
SELECT p.name AS patient_name, COUNT(*) AS appointment_count, d.name AS doctor_name
FROM patient p
INNER JOIN appointment a ON p.patient_ID = a.patient_ID
INNER JOIN doctor d ON a.doctor_ID = d.doctor_ID
GROUP BY p.patient_ID, p.name, d.name
HAVING COUNT(*) < 3;

--Sélectionner les patients et les médecins qui ont des rendez-vous prévus pour une date donnée, triés par ordre alphabétique du nom du patient :
SELECT p.name AS patient_name, d.name AS doctor_name
FROM patient p
INNER JOIN appointment a ON p.patient_ID = a.patient_ID
INNER JOIN doctor d ON a.doctor_ID = d.doctor_ID
WHERE a.appointment_date = '2023-06-10'
ORDER BY p.name;

--Sélectionner les patients qui ont des rendez-vous prévus avec des médecins spécialisés en cardiologie, triés par ordre croissant de la date de rendez-vous :
SELECT p.name AS patient_name, a.appointment_date, d.name AS doctor_name
FROM patient p
INNER JOIN appointment a ON p.patient_ID = a.patient_ID
INNER JOIN doctor d ON a.doctor_ID = d.doctor_ID
WHERE d.speciality = 'Cardiology'
ORDER BY a.appointment_date;

--Sélectionner les patients ayant au plus 1 rendez-vous et afficher leur nom, le nom du médecin qui les a traités, et dans quel département :
SELECT p.name AS patient_name, d.name AS doctor_name, dep.department_name
FROM patient p
LEFT JOIN appointment a ON p.patient_ID = a.patient_ID
LEFT JOIN doctor d ON a.doctor_ID = d.doctor_ID
LEFT JOIN department dep ON d.department_ID = dep.department_ID
GROUP BY p.patient_ID, p.name, d.name, dep.department_name
HAVING COUNT(a.appointment_ID) <= 1;


