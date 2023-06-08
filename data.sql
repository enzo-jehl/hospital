INSERT INTO Department (Department_Name)
VALUES
  ('Cardiology'),
  ('Pediatrics'),
  ('Orthopedics'),
  ('Neurology');

INSERT INTO Nurse (Name, Contact_Number, Email, number_of_assigned_patients)
VALUES
  ('Nurse Emily Thompson', '5551112222', 'emily.thompson@example.com', 0),
  ('Nurse Mark Wilson', '5553334444', 'mark.wilson@example.com', 0),
  ('Nurse Lisa Johnson', '5556667777', 'lisa.johnson@example.com', 0),
  ('Nurse Theo Oliver', '2226667777', 'theo.oliver@example.com', 0);

INSERT INTO Patient (Name, Gender, Date_of_Birth, Contact_Number, Address, contacted_department)
VALUES
  ('Flavien Geoffray', 'M', '2003-10-03', '1234567890', '789 Maple Street', 'Cardiology'),
  ('Alexiane Laroye', 'F', '2003-04-06', '9876543210', '567 Oakwood Avenue', 'Pediatrics'),
  ('Enzo Jehl', 'M', '2003-10-10', '5555555555', '456 Elmwood Drive', 'Orthopedics'),
  ('Wissame Ismael', 'M', '2004-08-29', '1516484622', '233 Togo Street', 'Neurology');

INSERT INTO Doctor (Name, Speciality, Contact_Number, Email, Department_ID)
VALUES
  ('Dr. Sarah Adams', 'Cardiology', '5551234567', 'sarah.adams@example.com', 1),
  ('Dr. Michael Davis', 'Pediatrics', '5559876543', 'michael.davis@example.com', 2),
  ('Dr. Jennifer Lee', 'Orthopedics', '5555555555', 'jennifer.lee@example.com', 3),
  ('Dr. Doctor', 'Neurology', '5555522255', 'dotordoctor@example.com', 4);

INSERT INTO Appointment (Appointment_ID, Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Appointment_Status)
VALUES
  (1, 1, 1, '2023-06-10', '10:00:00', 'Scheduled'),
  (2, 2, 2, '2023-06-11', '15:30:00', 'Scheduled'),
  (3, 3, 3, '2023-06-12', '14:00:00', 'Scheduled'),
  (4, 4, 4, '2023-06-13', '16:00:00', 'Scheduled');

INSERT INTO Medical_Record (Medical_Record_ID, Patient_ID, Admission_Date, Discharge_Date, Diagnosis)
VALUES
  (1, 1, '2023-06-10', '2023-06-15', 'Hypertension'),
  (2, 2, '2023-06-11', '2023-06-16', 'Common cold'),
  (3, 3, '2023-06-12', '2023-06-17', 'Fractured ankle'),
  (4, 4, '2023-06-13', '2023-06-18', 'Parkinson');

INSERT INTO Medication (Medication_Name, Medication_Dosage)
VALUES
  ('Aspirin', '500mg'),
  ('Amoxicillin', '250mg'),
  ('Ibuprofen', '200mg'),
  ('Sprite', '1kg');
