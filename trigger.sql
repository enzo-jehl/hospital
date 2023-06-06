trigger :
	-Id pour docteur, nurse, patient, medication (fait)
	-assignement automatic d'une nurse a un nouveaux patient
	-assignement d'un docteur puis création d'un appointement
	-docteur assigner departement
	-create new medical record
	-création d'une table non remplie pour le patient_médication
	-création du dossier médical du patient
	-lors de la suppretion d'un patien suprime aussi le médical record, les appointement, le patient médication et le patient_doctor qui lui sont reliée
	-lors de la suprésion d'une nurse/doc réassignement automatic d'une nouvelle nurse/doc
	
	
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

