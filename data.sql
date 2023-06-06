

INSERT INTO Patient (Patient_ID, Name, Gender, Date_of_Birth, Contact_Number, Address)
VALUES
  (1, 'Flavien Geoffray', 'M', '2003-10-03', '1234567890', '789 Maple Street'),
  (2, 'Alexiane Laroye', 'F', '2003-04-06', '9876543210', '567 Oakwood Avenue'),
  (3, 'Enzo Jehl', 'Male', '2003-10-10', '5555555555', '456 Elmwood Drive'),
  (4, 'Wissame Ismael', 'Male', '2004-08-29','1516484622', '233 Togo Street');
  

INSERT INTO Doctor (Doctor_ID, Name, Specialty, Contact_Number, Email)
VALUES
  (1, 'Dr. Sarah Adams', 'Cardiology', '5551234567', 'sarah.adams@example.com'),
  (2, 'Dr. Michael Davis', 'Pediatrics', '5559876543', 'michael.davis@example.com'),
  (3, 'Dr. Jennifer Lee', 'Orthopedics', '5555555555', 'jennifer.lee@example.com'),
  (4, 'Dr. Doctor', 'Neurology', '5555522255', 'dotordoctor@example.com');
  

INSERT INTO Nurse (Nurse_ID, Name, Contact_Number, Email)
VALUES
  (1, 'Nurse Emily Thompson', '5551112222', 'emily.thompson@example.com'),
  (2, 'Nurse Mark Wilson', '5553334444', 'mark.wilson@example.com'),
  (3, 'Nurse Lisa Johnson', '5556667777', 'lisa.johnson@example.com'),
  (4, 'Nurse Theo Oliver', '2226667777', 'theo.oliver@example.com');
  

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

INSERT INTO Medication (Medication_ID, Medication_Name, Medication_Dosage)
VALUES
  (1, 'Aspirin', '500mg'),
  (2, 'Amoxicillin', '250mg'),
  (3, 'Ibuprofen', '200mg'),
  (4, 'Sprite', '1kg')4

INSERT INTO Department (Department_ID, Department_Name)
VALUES
  (1, 'Cardiology'),
  (2, 'Pediatrics'),
  (3, 'Orthopedics'),
  (4, 'Neurology');
