-- ********** Create Carejoy Schema ********** --

CREATE SCHEMA IF NOT EXISTS carejoy;

-- ********** CORE ********** --
CREATE SEQUENCE carejoy.core_patient_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

DROP TABLE IF EXISTS carejoy.core_patient;
CREATE TABLE carejoy.core_patient
(
  id bigint NOT NULL DEFAULT nextval('carejoy.core_patient_seq'::regclass),
  address1 character varying(255),
  address2 character varying(255),
  patient_uuid character varying(255),
  user_id bigint, -- Dynamo/Carejoy user to which this patient is associated with
  organization_id bigint, -- Dynamo/Carejoy organization to which this patient belongs to.
  city character varying(255),
  country character varying(255),
  deceased boolean NOT NULL,
  dob character varying(255),
  date_of_birth date,
  ethnicity character varying(255),
  first_name character varying(255),
  full_name character varying(255),
  gender character varying(255),
  home_phone character varying(255),
  last_name character varying(255),
  middle_initial character varying(255),
  mobile_phone character varying(255),
  race character varying(255),
  ssn character varying(255),
  state character varying(255),
  work_phone character varying(255),
  zip_code character varying(255),
  external_patient_id character varying(255),
  external_patient_source character varying(255),
  CONSTRAINT pr_patient_pkey PRIMARY KEY (id),
  CONSTRAINT pr_patient_oid_fk FOREIGN KEY (organization_id)
      REFERENCES dynamo.organization (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT core_patient_user_fkey FOREIGN KEY (user_id)
      REFERENCES dynamo.dynamo_user (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- ********** Carejoy Setup Data ********** --

-- Add Carejoy Specific roles
INSERT INTO dynamo.role (id, organization_id, name, description, created_date, modified_date) VALUES (4,2, 'CLINICIAN','Clinician', now(), now()), (5,2, 'CARETEAM_USER','Careteam User', now(), now()), (6,2, 'DATA_ANALYST','Data Analyst', now(), now()), (7,2, 'PATIENT','Patient', now(), now());
select setval('dynamo.role_seq', (select max(id)+1 from dynamo.role), false);

-- Update the role_seq after all the sample data inserts.
select setval('dynamo.role_seq', (select max(id)+1 from dynamo.role), false);

-- Add carejoy admin specific properties
INSERT INTO properties (id, application, profile, label, key, value) VALUES (3, 'carejoyadminwebapp', 'DBAuthentication','master','enableAuditing','true'), (4, 'carejoyadminwebapp', 'DBAuthentication','master','applicationServerAddress','http://localhost:8080');
INSERT INTO properties (id, application, profile, label, key, value) VALUES (5, 'carejoywebapp', 'DBAuthentication','master','enableAuditing','true'), (6, 'carejoywebapp', 'DBAuthentication','master','applicationServerAddress','http://localhost:8080');

-- Update properties_seq after all the sample data inserts.
select setval('properties_seq', (select max(id)+1 from properties), false);

-- Assign Carejoy roles to sample user
INSERT INTO dynamo.user_role_map (user_id, role_id, created_date, modified_date) VALUES (1,4,now(),now()),(1,5,now(),now()),(1,6,now(),now());

-- Update user_role_map_seq after all the sample data inserts.
select setval('dynamo.user_role_map_seq', (select max(id)+1 from dynamo.user_role_map), false);