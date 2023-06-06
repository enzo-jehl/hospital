drop table if exists patient_doctor;
drop table if exists patient_nurse;
drop table if exists patient_medication;
drop table if exists medical_record;
drop table if exists nurse;
drop table if exists appointment;
drop table if exists department;
drop table if exists medication;
drop table if exists patient;
drop table if exists doctor;


create table patient(
	patient_ID int primary key,
	name varchar(40),
	gender char(1),
	date_of_birth date,
	contact_number varchar(40),
	address varchar(40),
	contacted_department varchar(40)
	);
	
create table doctor(
	doctor_ID int primary key,
	name varchar(40),
	speciality varchar(40),
	contact_number varchar(40),
	email varchar(40)
	);
	
create table nurse(
	nurse_ID int primary key,
	name varchar(40),
	contact_number varchar(40),
	email varchar(40),
	number_of_assigned_patients int
	);
	
create table department(
	department_ID int primary key,
	department_name varchar(40)
	);
	
create table appointment(
	appointment_ID int primary key,
	appointment_date date,
	appointment_time time,
	appointment_status varchar(40),
	patient_ID int,
	doctor_ID int,
	foreign key (patient_ID) references patient(patient_ID),
	foreign key (doctor_ID) references doctor(doctor_ID)
	);

create table medical_record(
	medical_record_ID int primary key,
	admission_date date,
	discharge_date date,
	diagnosis varchar(40),
	patient_ID int,
	foreign key (patient_ID) references patient(patient_ID)
	);
	
create table medication(
	medication_ID int primary key,
	medication_name varchar(40),
	medication_dosage varchar(40)
	);
	
create table patient_doctor(
	patient_ID int,
	doctor_ID int,
	primary key (patient_ID, doctor_ID),
	foreign key (patient_ID) references patient(patient_ID),
	foreign key (doctor_ID) references doctor(doctor_ID)
	);
	
create table patient_nurse(
	patient_ID int,
	nurse_ID int,
	primary key (patient_ID, nurse_ID),
	foreign key (patient_ID) references patient(patient_ID),
	foreign key (nurse_ID) references nurse(nurse_ID)
	);
	
create table patient_medication(
	patient_ID int,
	medication_ID int,
	prescription_date date,
	foreign key (patient_ID) references patient(patient_ID),
	foreign key (medication_ID) references medication(medication_ID)
	);


	
