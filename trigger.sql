trigger :
	-Id pour docteur, nurse, patient, medication (fait)
	-assignement automatic d'une nurse a un nouveaux patient (fait)
	-docteur assigner departement(fait)
	-create new medical record(fait)
	-création d'une table non remplie pour le patient_médication (a faire)
	-lors de la suppretion d'un patien suprime aussi le médical record, les appointement, le patient médication et le patient_doctor qui lui sont reliée
	-lors de la suprésion d'une nurse/doc réassignement automatic d'une nouvelle nurse/doc
	-assignement d'un docteur puis création d'un appointement 
	
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

CREATE TRIGGER assign_id_trigger
BEFORE INSERT ON patient
FOR EACH ROW
EXECUTE FUNCTION assign_id_functionPa();


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

CREATE TRIGGER assign_id_trigger
BEFORE INSERT ON doctor
FOR EACH ROW
EXECUTE FUNCTION assign_id_functionDoc();


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

CREATE TRIGGER assign_id_trigger
BEFORE INSERT ON nurse
FOR EACH ROW
EXECUTE FUNCTION assign_id_functionNu();


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

CREATE TRIGGER assign_id_trigger
BEFORE INSERT ON medication
FOR EACH ROW
EXECUTE FUNCTION assign_id_functionMed();


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


CREATE OR REPLACE FUNCTION create_medication()
RETURNS TRIGGER AS $$
DECLARE
    new_id INTEGER;
BEGIN
    SELECT COALESCE(MAX(medication_id), 0) + 1 INTO new_id FROM medication;
    
	INSERT INTO medication (medication_id)
    VALUES (new_id);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER create_medication
AFTER INSERT ON patient
FOR EACH ROW
EXECUTE FUNCTION create_medication();

