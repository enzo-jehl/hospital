-- display all patient ids from today appointments
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

-- change the appointment status with status
CREATE OR REPLACE PROCEDURE changeappstatus (app_ID int, status varchar(40))
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE appointment 
    SET appointment_status = status
    WHERE appointment_ID = app_ID;
END;
$$;
    	
-- display doctors info of spec
CREATE OR REPLACE FUNCTION specialistlist(spec varchar(40))
RETURNS SETOF doctor
AS $$
BEGIN
    RETURN QUERY SELECT * FROM doctor WHERE speciality = spec;
END;
$$ LANGUAGE plpgsql;

-- display the medical record of a given patient id
CREATE OR REPLACE function showmedicalrecord (id int)
RETURNS SETOF medical_record
AS $$
BEGIN
   return query SELECT * FROM medical_record WHERE patient_id = id;
END;
$$ LANGUAGE plpgsql;

-- show the name of the medication that takes the given patient id
CREATE OR REPLACE FUNCTION show_patient_medication(id INT)
RETURNS TABLE (
    medication_name VARCHAR(40)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT m.medication_name
    FROM medication m
    JOIN patient_medication pm ON m.medication_ID = pm.medication_ID
    JOIN medical_record mr ON pm.patient_ID = mr.patient_ID
    WHERE mr.patient_ID = id;
END;
$$ LANGUAGE plpgsql;

-- update the patient_medication table
CREATE OR REPLACE PROCEDURE changepatientmedication (npatient_ID int, nmedication_id int)
AS $$
BEGIN
    UPDATE patient_medication
    SET medication_id = nmedication_id, prescription_date = NOW()
    WHERE patient_id = npatient_ID;
END;
$$ LANGUAGE plpgsql;

--display all patients assigned to the given nurse
CREATE OR REPLACE function shownursepatients (id int)
RETURNS SETOF patient
AS $$
BEGIN
   return query SELECT * FROM patient WHERE nurse_id = id;
END;
$$ LANGUAGE plpgsql;

-- show the number of patient of the given nurse
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

-- update the given nurse infos
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

-- show the name of patients who have an appointment with the given doctor
CREATE OR REPLACE FUNCTION showdocspatients(id INT)
RETURNS TABLE (
    patient_name VARCHAR(40)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT p.name
    FROM patient p
    INNER JOIN appointment a ON p.patient_ID = a.patient_ID
    WHERE a.doctor_ID = id;
END;
$$ LANGUAGE plpgsql;

-- show all appointments by the give status
CREATE OR REPLACE FUNCTION get_appointments_by_status(status VARCHAR(40))
RETURNS TABLE (
    patient_name VARCHAR(40),
    doctor_name VARCHAR(40)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT p.name AS patient_name, d.name AS doctor_name
    FROM appointment a
    INNER JOIN patient p ON a.patient_ID = p.patient_ID
    INNER JOIN doctor d ON a.doctor_ID = d.doctor_ID
    WHERE a.appointment_status = status;
END;
$$ LANGUAGE plpgsql;

-- procedure to update the given doctor infos
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



-- test cases
select todaysapps('2023-06-10');
call changeappstatus(1, 'in progress');
select specialistlist('Cardiology');
select showmedicalrecord(2);
select * from show_patient_medication(2);
call changepatientmedication(1,2);
select shownursepatients(1);
select getnumberofpatient(1);
call changeinfosnurse(4, 'paul@gmail.com', '1111111111');
select showdocspatients(1);
select get_appointments_by_status('Scheduled');
call changeinfosdoctor(1, 'dark911destructor@gmail.com', '6666666666');





