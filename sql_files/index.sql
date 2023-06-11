-- Creation of a composite index on the patient_ID and doctor_ID columns of the appointment table
CREATE INDEX idx_appointment_patient_doctor ON appointment(patient_ID, doctor_ID);

-- Creation of an index on the department_name column of the department table
CREATE INDEX idx_department_department_name ON department(department_name);

-- Creation of an index on the name column of the nurse table
CREATE INDEX idx_nurse_name ON nurse(name);

-- Creation of an index on the name and contact_number columns of the patient table
CREATE INDEX idx_patient_name_contact_number ON patient(name, contact_number);

-- Creation of an index on the specialty column of the doctor table
CREATE INDEX idx_doctor_speciality ON doctor(speciality);

-- Creation of an index on the patient_ID and admission_date columns of the medical_record table
CREATE INDEX idx_medical_record_patient_admission_date ON medical_record(patient_ID, admission_date);

-- Creation of an index on the medication_name column of the medication table
CREATE INDEX idx_medication_medication_name ON medication(medication_name);

-- Creation of an index on the patient_ID and prescription_date columns of the patient_medication table
CREATE INDEX idx_patient_medication_patient_prescription_date ON patient_medication(patient_ID, prescription_date);

--Indexing is an important technique to enhance database performance. Indexes accelerate search, join, and filtering operations by creating additional 
--data structures that facilitate quick access to matching records. However, it's important to note that creating indexes can also impact the performance of
--insertion, update, and deletion operations, as indexes need to be maintained during these operations. 
--Therefore, it's necessary to strike a proper balance based on the specific needs of the database and executed queries.
