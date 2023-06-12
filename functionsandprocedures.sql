
CREATE OR REPLACE FUNCTION todaysapps (today date)
RETURNS int
AS $$
DECLARE
    patientID int;
BEGIN
    SELECT patient_ID INTO patientID FROM appointment WHERE appointment_date = today;
    RETURN patientID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE changeappstatus (app_ID int, status varchar(40))
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE appointment 
    SET appointment_status = status
    WHERE appointment_ID = app_ID;
END;
$$;
    	
CREATE OR REPLACE FUNCTION specialistlist(spec varchar(40))
RETURNS SETOF doctor
AS $$
BEGIN
    RETURN QUERY SELECT * FROM doctor WHERE speciality = spec;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE function showmedicalrecord (id int)
RETURNS SETOF medical_record
AS $$
BEGIN
   return query SELECT * FROM medical_record WHERE patient_id = id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE function showpatientmedication (id int)
RETURNS SETOF patient_medication
AS $$
BEGIN
   return query SELECT * FROM patient_medication WHERE patient_id = id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE changepatientmedication (npatient_ID int, nmedication_id int)
AS $$
BEGIN
    UPDATE patient_medication
    SET medication_id = nmedication_id, prescription_date = NOW()
    WHERE patient_id = npatient_ID;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE function shownursepatients (id int)
RETURNS SETOF patient
AS $$
BEGIN
   return query SELECT * FROM patient WHERE nurse_id = id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getnumberofpatient (id int)
RETURNS int
AS $$
DECLARE
    num_of_patients int;
BEGIN
    SELECT number_of_assigned_patients INTO num_of_patients FROM nurse WHERE nurse_id = id;
    RETURN num_of_patients;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE changeinfosnurse (id int, nemail varchar(40), ncontact_number varchar(40))
AS $$
BEGIN
    IF nemail IS NOT NULL THEN
        UPDATE nurse
        SET email = nemail
        WHERE nurse_id = id;
    END IF;
    
    IF ncontact_number IS NOT NULL THEN
        UPDATE nurse
        SET contact_number = ncontact_number
        WHERE nurse_id = id;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION showdocspatients(id_doctor INT)
RETURNS SETOF patient
AS $$
BEGIN
   RETURN QUERY SELECT * FROM patient 
   WHERE patient_id 
   IN (SELECT patient_id FROM patient_doctor WHERE doctor_id = id_doctor);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION showpatientsdoc(id_patient INT)
RETURNS SETOF doctor
AS $$
BEGIN
   RETURN QUERY SELECT * FROM doctor 
   WHERE doctor_id 
   IN (SELECT doctor_id FROM patient_doctor WHERE patient_id = id_patient);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE changeinfosdoctor (id int, nemail varchar(40), ncontact_number varchar(40))
AS $$
BEGIN
    IF nemail IS NOT NULL THEN
        UPDATE doctor
        SET email = nemail
        WHERE doctor_id = id;
    END IF;
    
    IF ncontact_number IS NOT NULL THEN
        UPDATE doctor
        SET contact_number = ncontact_number
        WHERE doctor_id = id;
    END IF;
END;
$$ LANGUAGE plpgsql;
