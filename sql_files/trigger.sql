--trigger for the ID of patient

CREATE OR REPLACE FUNCTION assign_id_functionPa()
RETURNS TRIGGER AS $$
DECLARE
    last_id INT;
BEGIN
    SELECT MAX(patient_id) INTO last_id FROM patient;
    IF last_id IS NULL THEN
        NEW.patient_id := 1;
    ELSE
        NEW.patient_id := last_id + 1;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER assign_id_trigger
BEFORE INSERT ON patient
FOR EACH ROW
EXECUTE FUNCTION assign_id_functionPa();




--trigger for the ID of doctor

CREATE OR REPLACE FUNCTION assign_id_functionDoc()
RETURNS TRIGGER AS $$
DECLARE
    last_id INT;
BEGIN
    SELECT MAX(doctor_id) INTO last_id FROM doctor;
    IF last_id IS NULL THEN
        NEW.doctor_id := 1;
    ELSE
        NEW.doctor_id := last_id + 1;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER assign_id_trigger
BEFORE INSERT ON doctor
FOR EACH ROW
EXECUTE FUNCTION assign_id_functionDoc();




--trigger for the ID of nurse

CREATE OR REPLACE FUNCTION assign_id_functionNu()
RETURNS TRIGGER AS $$
DECLARE
    last_id INT;
BEGIN
    SELECT MAX(nurse_id) INTO last_id FROM nurse;
    IF last_id IS NULL THEN
        NEW.nurse_id := 1;
    ELSE
        NEW.nurse_id := last_id + 1;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER assign_id_trigger
BEFORE INSERT ON nurse
FOR EACH ROW
EXECUTE FUNCTION assign_id_functionNu();




--trigger for the ID of medication

CREATE OR REPLACE FUNCTION assign_id_functionMed()
RETURNS TRIGGER AS $$
DECLARE
    last_id INT;
BEGIN
    SELECT MAX(medication_id) INTO last_id FROM medication;
    IF last_id IS NULL THEN
        NEW.medication_id := 1;
    ELSE
        NEW.medication_id := last_id + 1;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER assign_id_trigger
BEFORE INSERT ON medication
FOR EACH ROW
EXECUTE FUNCTION assign_id_functionMed();




--trigger for the ID of department

CREATE OR REPLACE FUNCTION assign_id_functionDep()
RETURNS TRIGGER AS $$
DECLARE
    last_id INT;
BEGIN
    SELECT MAX(department_id) INTO last_id FROM department;
    IF last_id IS NULL THEN
        NEW.department_id := 1;
    ELSE
        NEW.department_id := last_id + 1;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER assign_id_trigger
BEFORE INSERT ON department
FOR EACH ROW
EXECUTE FUNCTION assign_id_functionDep();




--trigger to assigne a patient to the nurse with the less number a patient

CREATE OR REPLACE FUNCTION assign_nurse_to_patient()
RETURNS TRIGGER AS $$
DECLARE
    nurs_id INT;
BEGIN
    select min(nurse_id) into nurs_id from nurse where number_of_assigned_patients = (select min(number_of_assigned_patients) from nurse);

    NEW.nurse_id := nurs_id;

    UPDATE nurse SET number_of_assigned_patients = number_of_assigned_patients + 1 WHERE nurse_id = nurs_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER assign_nurse_trigger
BEFORE INSERT ON patient
FOR EACH ROW
EXECUTE FUNCTION assign_nurse_to_patient();




--trigger to assigne a doctor to his departement 

CREATE OR REPLACE FUNCTION assign_doctor_to_department()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.department_id IS NULL THEN
        SELECT department_id INTO NEW.department_id FROM department WHERE department_name = NEW.speciality;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER assign_doctor_trigger
BEFORE INSERT ON doctor
FOR EACH ROW
EXECUTE FUNCTION assign_doctor_to_department();




--trigger to create the medical record of a patient

CREATE OR REPLACE FUNCTION create_medical_record()
RETURNS TRIGGER AS $$
DECLARE
    new_id INTEGER;
BEGIN
    SELECT COALESCE(MAX(medical_record_id), 0) + 1 INTO new_id FROM medical_record;
    
	INSERT INTO medical_record (medical_record_id, patient_id, admission_date)
    VALUES (new_id, NEW.patient_id, current_date);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER create_medical_record_trigger
AFTER INSERT ON patient
FOR EACH ROW
EXECUTE FUNCTION create_medical_record();




--trigger to create the patient_medication

CREATE OR REPLACE FUNCTION create_patient_medication()
RETURNS TRIGGER AS $$
BEGIN
    
	INSERT INTO patient_medication (patient_id)
    VALUES (NEW.patient_id);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER create_patient_medication
AFTER INSERT ON patient
FOR EACH ROW
EXECUTE FUNCTION create_patient_medication();




--trigger to add the id of a medication to the patient medication when a doctor add a medication name

CREATE OR REPLACE FUNCTION assign_patient_medication_id()
RETURNS TRIGGER AS $$
DECLARE
    new_med_id INTEGER;
BEGIN
    SELECT medication_id INTO new_med_id FROM medication WHERE medication_name = NEW.patient_medication_name;
    UPDATE patient_medication
        SET medication_id = new_med_id where patient_medication_name = NEW.patient_medication_name;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER assign_patient_medication_id_trigger
AFTER UPDATE ON patient_medication
FOR EACH ROW
When (OLD.patient_medication_name IS DISTINCT FROM NEW.patient_medication_name)
EXECUTE FUNCTION assign_patient_medication_id();




--trigger to supr the medical_record, appointement, patient_medication and patient_doctor


CREATE OR REPLACE FUNCTION delete_patient()
RETURNS TRIGGER AS $$
DECLARE
    nurs_id INTEGER;
BEGIN
	SELECT nurse_id INTO nurs_id FROM nurse WHERE nurse_id = OLD.nurse_id;

    DELETE FROM medical_record WHERE patient_id = OLD.patient_id;
    
    DELETE FROM appointment WHERE patient_id = OLD.patient_id;
    
    DELETE FROM patient_medication WHERE patient_id = OLD.patient_id;
    
    DELETE FROM patient_doctor WHERE patient_id = OLD.patient_id;
    
    UPDATE nurse SET number_of_assigned_patients = number_of_assigned_patients - 1 WHERE nurse_id = nurs_id;
	
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER delete_patient_trigger
BEFORE DELETE ON patient
FOR EACH ROW
EXECUTE FUNCTION delete_patient();




--reassigne the nurse when deleted

CREATE OR REPLACE FUNCTION reassign_nurse()
RETURNS TRIGGER AS $$
DECLARE
    removed_nurse_id INTEGER;
    new_nurse_id INTEGER;
    patients_id INTEGER;
BEGIN
    removed_nurse_id := OLD.nurse_ID;

    -- Select patients ID from the deleted nurse
    SELECT patient_ID INTO patients_id
    FROM patient
    WHERE nurse_ID = removed_nurse_id
    LIMIT 1;

    -- loop to reassign patients to the new nurse one by one
    WHILE patients_id IS NOT NULL LOOP
        -- Select the new nurse with the least patients
        SELECT nurse_ID INTO new_nurse_id
        FROM nurse
        WHERE nurse_ID <> removed_nurse_id
        ORDER BY number_of_assigned_patients ASC
        LIMIT 1;

        -- Update the patient to reassigne the new nurse
        UPDATE patient
        SET nurse_ID = new_nurse_id
        WHERE patient_ID = patients_id;

        -- Update the number of patients of the new nurse
        UPDATE nurse
        SET number_of_assigned_patients = number_of_assigned_patients + 1
        WHERE nurse_ID = new_nurse_id;

        -- Select the next patient of the deleted nurse 
        SELECT patient_ID INTO patients_id
        FROM patient
        WHERE nurse_ID = removed_nurse_id
        LIMIT 1;
    END LOOP;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER reassign_nurse_trigger
before DELETE ON nurse
FOR EACH ROW
EXECUTE FUNCTION reassign_nurse();




--trigger to supr the appointement when a doctor is supr and also the table doctor_patient

CREATE OR REPLACE FUNCTION delete_doctor_appointments()
RETURNS TRIGGER AS $$
BEGIN

    -- delete the appointments linked to the doctor
    DELETE FROM appointment WHERE doctor_ID = OLD.doctor_ID;

    -- delete links patient-doctor for the deleted doctor
    DELETE FROM patient_doctor WHERE doctor_ID = OLD.doctor_ID;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER delete_doctor_appointments_trigger
BEFORE DELETE ON doctor
FOR EACH ROW
EXECUTE FUNCTION delete_doctor_appointments();
