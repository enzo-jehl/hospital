-- Création d'un index composite sur les colonnes patient_ID et doctor_ID de la table appointment
CREATE INDEX idx_appointment_patient_doctor ON appointment(patient_ID, doctor_ID);

-- Création d'un index sur la colonne department_name de la table department
CREATE INDEX idx_department_department_name ON department(department_name);

-- Création d'un index sur la colonne name de la table nurse
CREATE INDEX idx_nurse_name ON nurse(name);

-- Création d'un index sur les colonnes name et contact_number de la table patient
CREATE INDEX idx_patient_name_contact_number ON patient(name, contact_number);

-- Création d'un index sur la colonne speciality de la table doctor
CREATE INDEX idx_doctor_speciality ON doctor(speciality);

-- Création d'un index sur les colonnes patient_ID et admission_date de la table medical_record
CREATE INDEX idx_medical_record_patient_admission_date ON medical_record(patient_ID, admission_date);

-- Création d'un index sur la colonne medication_name de la table medication
CREATE INDEX idx_medication_medication_name ON medication(medication_name);

-- Création d'un index sur les colonnes patient_ID et prescription_date de la table patient_medication
CREATE INDEX idx_patient_medication_patient_prescription_date ON patient_medication(patient_ID, prescription_date);
