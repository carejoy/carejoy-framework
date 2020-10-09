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

-- ********** FHIR ********** --
    
CREATE SEQUENCE carejoy.fhir_resource_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
    
DROP TABLE IF EXISTS carejoy.fhir_resource;
CREATE TABLE carejoy.fhir_resource
(
  id bigint NOT NULL DEFAULT nextval('carejoy.fhir_resource_seq'::regclass),
  type character varying(64),
  resource_content jsonb,
  created_on timestamp with time zone,
  modified_on timestamp with time zone,
  CONSTRAINT fhir_resource_pkey PRIMARY KEY (id)
);

-- ********** PGHD ********** --

CREATE SEQUENCE carejoy.pghd_patient_pghd_token_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

DROP TABLE IF EXISTS carejoy.pghd_patient_pghd_token;
CREATE TABLE carejoy.pghd_patient_pghd_token
(
  id bigint NOT NULL DEFAULT nextval('carejoy.pghd_patient_pghd_token_seq'::regclass),
  patient_id uuid NOT NULL,
  access_token character varying(255),
  refresh_token character varying(255),
  expires_at timestamp with time zone,
  source character varying(100),
  patient_id_at_source character varying(100),
  modified_date timestamp with time zone,
  CONSTRAINT pghd_patient_pghd_token_pkey PRIMARY KEY (id)
);


CREATE SEQUENCE carejoy.pghd_pghd_feed_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

DROP TABLE IF EXISTS carejoy.pghd_pghd_feed;
CREATE TABLE carejoy.pghd_pghd_feed
(
  id bigint NOT NULL DEFAULT nextval('carejoy.pghd_pghd_feed_seq'::regclass),
  source character varying(64),
  date_received timestamp with time zone,
  pghd_type character varying(64),
  pghd_json_value character varying,
  CONSTRAINT pghd_pghd_feed_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE carejoy.pghd_patient_pghd_feed_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

DROP TABLE IF EXISTS carejoy.pghd_patient_pghd_feed;
CREATE TABLE carejoy.pghd_patient_pghd_feed
(
  id bigint NOT NULL DEFAULT nextval('carejoy.pghd_patient_pghd_feed_seq'::regclass),
  patient_id uuid NOT NULL,
  pghd_feed_id bigint NOT NULL,
  status character varying(48),
  modified_date timestamp with time zone,
  CONSTRAINT pghd_patient_pghd_feed_pkey PRIMARY KEY (id),
  CONSTRAINT pghd_patient_pghd_feed_feedid_fk FOREIGN KEY (pghd_feed_id)
      REFERENCES carejoy.pghd_pghd_feed (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE SEQUENCE carejoy.pghd_patient_pghd_reading_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

DROP TABLE IF EXISTS carejoy.pghd_patient_pghd_reading;
CREATE TABLE carejoy.pghd_patient_pghd_reading
(
  id bigint NOT NULL DEFAULT nextval('carejoy.pghd_patient_pghd_reading_seq'::regclass),
  patient_id uuid,
  pghd_source character varying(64),
  pghd_type character varying(64),
  reading_date timestamp with time zone,
  value character varying(32),
  unit character varying(32),
  meal_status character varying(64),
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  active boolean,
  CONSTRAINT pghd_patient_pghd_reading_pkey PRIMARY KEY (id)
 );

CREATE SEQUENCE carejoy.pghd_iglucose_notification_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
DROP TABLE IF EXISTS carejoy.pghd_iglucose_notification;
CREATE TABLE carejoy.pghd_iglucose_notification
(
  id bigint NOT NULL DEFAULT nextval('carejoy.pghd_iglucose_notification_seq'::regclass),
  notification_json_value character varying,
  status varchar(48),
  notification_date timestamp with time zone,
  CONSTRAINT pghd_iglucose_notification_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE carejoy.pghd_patient_device_map_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
DROP TABLE IF EXISTS carejoy.pghd_patient_device_map;
CREATE TABLE carejoy.pghd_patient_device_map
(
  id bigint NOT NULL DEFAULT nextval('carejoy.pghd_patient_device_map_seq'::regclass),
  patient_id uuid NOT NULL,
  device_id varchar(128) NOT NULL,
  device_model varchar(128) NOT NULL,
  device_source varchar(64) NOT NULL,
  device_type varchar(64) NOT NULL,
  modified_date timestamp with time zone,
  CONSTRAINT pghd_patient_device_map_pkey PRIMARY KEY (id),
  UNIQUE(patient_id,device_id,device_model)
);

-- ********** Carejoy EHR ********** --
CREATE SEQUENCE carejoy.ehr_ehr_info_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
  
DROP TABLE IF EXISTS carejoy.ehr_ehr_info;
CREATE TABLE carejoy.ehr_ehr_info
(
  id bigint NOT NULL DEFAULT nextval('carejoy.ehr_ehr_info_seq'::regclass),
  ehr_carejoy_organization_id bigint,
  ehr_name varchar(64) NOT NULL,
  practice_id varchar(64),
  access_token varchar(255),
  refresh_token varchar(255),
  expires_at timestamp with time zone,
  client_id varchar,
  client_secret varchar,
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  CONSTRAINT ehr_ehr_info_pkey PRIMARY KEY (id)
);


-- ********** Carejoy CCDA ********** --

CREATE SEQUENCE carejoy.ccda_upload_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
CREATE TABLE carejoy.ccda_upload
(
  id bigint NOT NULL DEFAULT nextval('carejoy.ccda_upload_seq'::regclass),
  organization_id bigint, -- Dynamo/Carejoy organization to which this patient belongs to.
  uploaded_date timestamp with time zone,
  status character varying(255),
  unique_id character varying(255),
  patient_uuid uuid,
  original_filename character varying(255),
  patient_record_dto bytea,
  consolidated_dto bytea,
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  CONSTRAINT ccda_upload_pkey PRIMARY KEY (id),
  CONSTRAINT ccda_upload_oid_fk FOREIGN KEY (organization_id)
      REFERENCES dynamo.organization (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- ********** Carejoy Careplan Management ********** --

CREATE SEQUENCE carejoy.cpm_resource_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE carejoy.cpm_resource
(
  id bigint NOT NULL DEFAULT nextval('carejoy.cpm_resource_seq'::regclass),
  fhir_version character varying(64) NOT NULL,
  resource_type character varying(255) NOT NULL,
  resource_id character varying(255) NOT NULL,
  resource_name character varying(255),
  json_resource jsonb,
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  CONSTRAINT cpm_resource_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE carejoy.cpm_patientcareplan_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE carejoy.cpm_patientcareplan
(
  id bigint NOT NULL DEFAULT nextval('carejoy.cpm_patientcareplan_seq'::regclass),
  patient_uuid uuid,
  plan_definition_resource_id bigint, 
  status character varying(64),
  date_assigned timestamp with time zone,
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  CONSTRAINT cpm_patientcareplan_pkey PRIMARY KEY (id),
  CONSTRAINT fktkrb3ycds0cg5q1f4b7benu0_pcd FOREIGN KEY (plan_definition_resource_id)
      REFERENCES carejoy.cpm_resource (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
 );
 
 
 CREATE SEQUENCE carejoy.cpm_pcp_resource_map_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE carejoy.cpm_pcp_resource_map
(
  id bigint NOT NULL DEFAULT nextval('carejoy.cpm_pcp_resource_map_seq'::regclass),
  patientcareplan_id bigint,
  resource_id bigint, 
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  CONSTRAINT cpm_pcp_resource_map_pkey PRIMARY KEY (id),
  CONSTRAINT fktkrb3ycds0cg5q1f4b7benu0_rid FOREIGN KEY (resource_id)
      REFERENCES carejoy.cpm_resource (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fktkrb3ycds0cg5q1f4b7benu0_pcpid FOREIGN KEY (patientcareplan_id)
      REFERENCES carejoy.cpm_patientcareplan (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
 
-- set sample data
 \set content `cat /tmp/psql/carejoy/careplanmanagement/HypertensionPlanDefinition.json`
 INSERT INTO carejoy.cpm_resource (fhir_version, resource_type, resource_id, resource_name, json_resource, created_date, modified_date) values ('R4', 'PLANDEFINITION', '21b48010-7d88-4120-84d7-81a10bf71df0', 'Hypertension Plan Definition', :'content', now(), now());
 
 \set content `cat /tmp/psql/carejoy/careplanmanagement/ObesityAssessmentPlanDefinition.json`
 INSERT INTO carejoy.cpm_resource (fhir_version, resource_type, resource_id, resource_name, json_resource, created_date, modified_date) values ('R4', 'PLANDEFINITION', 'd77eaabc-1b1a-42e0-a850-e10413a362ac', 'Obesity Assessment Plan Definition', :'content', now(), now());

 \set content `cat /tmp/psql/carejoy/careplanmanagement/AntiCoagulationTherapyPlanDefinition.json`
 INSERT INTO carejoy.cpm_resource (fhir_version, resource_type, resource_id, resource_name, json_resource, created_date, modified_date) values ('R4', 'PLANDEFINITION', 'd77eaabc-1b1a-42e0-a850-e10413a362ac', 'Anti-Coagulation Therapy Plan Definition', :'content', now(), now());

 \set content `cat /tmp/psql/carejoy/careplanmanagement/VeronicaPlanDefinition.json`
 INSERT INTO carejoy.cpm_resource (fhir_version, resource_type, resource_id, resource_name, json_resource, created_date, modified_date) values ('R4', 'PLANDEFINITION', '1d65c2cc-80bf-47c6-82bb-0d8f3953d9ca', 'Veronica Plan Definition', :'content', now(), now());





-- ********** Carejoy VSAC Value Sets ********** --

CREATE SEQUENCE carejoy.vsac_value_set_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE carejoy.vsac_value_set
(
  id bigint NOT NULL DEFAULT nextval('carejoy.vsac_value_set_seq'::regclass),
  oid character varying(180),
  value_set_name character varying(255),
  expansion_version character varying(180),
  code character varying(90),
  description character varying(512),
  code_system_name character varying(90),
  code_system_version character varying(90),
  code_system_oid character varying(180),
  purpose character varying,
  CONSTRAINT vsac_value_set_pkey PRIMARY KEY (id)
 );  
 
 
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.113762.1.4.1138.667.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.113883.3.464.1003.103.12.1010.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.113883.3.464.1003.198.12.1013.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.113883.3.526.2.25.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.113883.3.600.1.890.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.113883.3.600.2012.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.113883.3.600.263.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.113883.3.600.877.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.113883.3.600.883.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_2.16.840.1.114222.4.11.836.txt' DELIMITER '|';
COPY carejoy.vsac_value_set(oid, value_set_name, expansion_version, code, description, code_system_name, code_system_version, code_system_oid, purpose) FROM '/tmp/psql/carejoy/vsac-value-sets/value-set-codes_VS_2.16.840.1.113883.3.464.1003.103.12.1001.txt' DELIMITER '|';

-- ********** Carejoy Questionnaire ********** --

CREATE SEQUENCE carejoy.questionnaire_instance_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
CREATE SEQUENCE carejoy.questionnaire_instance_item_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
CREATE TABLE carejoy.questionnaire_instance
(
  id bigint NOT NULL DEFAULT nextval('carejoy.questionnaire_instance_seq'::regclass),
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  questionnaire_id character varying(255),
  questionnaire_model character varying(255),
  username character varying(255),
  CONSTRAINT questionnaire_instance_pkey PRIMARY KEY (id)
);

CREATE TABLE carejoy.questionnaire_instance_item
(
  id bigint NOT NULL DEFAULT nextval('carejoy.questionnaire_instance_item_seq'::regclass),
  created_date timestamp with time zone,
  instance_id bigint,
  modified_date timestamp with time zone,
  question_label character varying(255),
  question_value character varying(255),
  sequence_number integer,
  username character varying(255),
  CONSTRAINT questionnaire_instance_item_pkey PRIMARY KEY (id),
  CONSTRAINT fktkrb3ycds0cg5q1f4b7benu0 FOREIGN KEY (instance_id)
      REFERENCES carejoy.questionnaire_instance (id) MATCH SIMPLE
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

-- Add entry to ehr_ehr_info table for Athena sandbox integration
INSERT INTO carejoy.ehr_ehr_info(
            id, ehr_carejoy_organization_id, ehr_name, practice_id, access_token, 
            refresh_token, expires_at, client_id, client_secret, created_date, 
            modified_date)
    VALUES (1, 2, 'ATHENA', '195900', 'pgphqx8r6fewgzfh2kwd3hhg', 
            'wwqgb6bh6uy6d2fbv8tawx93', now(), '5zy4u4nxbmqptnpquf9jrcmt', '8VuMh4HPWuAcGnP', now(), 
            now());

-- *************** Carejoy Remote Patient Monitoring ************ --

CREATE SEQUENCE carejoy.rpm_patientdevicemap_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
CREATE TABLE carejoy.rpm_patientdevicemap
(
  id bigint NOT NULL DEFAULT nextval('carejoy.rpm_patientdevicemap_seq'::regclass),
  patient_uuid uuid,
  device_id bigint,
  created_date timestamp with time zone,
  modified_date timestamp with time zone, 
  CONSTRAINT rpm_patientdevicemap_pkey PRIMARY KEY (id),
  CONSTRAINT rpm_patientdevicemap_fkey FOREIGN KEY (device_id)
  	REFERENCES cadence.device (id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
);  

CREATE SEQUENCE carejoy.rpm_fitbitdevicedata_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE carejoy.rpm_fitbitdevicedata
(
  id bigint NOT NULL DEFAULT nextval('carejoy.rpm_fitbitdevicedata_seq'::regclass),
  activity_steps integer,
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  patient_device_id bigint,
  CONSTRAINT rpm_fitbitdevicedata_pkey PRIMARY KEY (id),
  CONSTRAINT fkm7lxgppixucu00279uq30ml9h FOREIGN KEY (patient_device_id)
      REFERENCES carejoy.rpm_patientdevicemap (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE SEQUENCE carejoy.rpm_fitbittoken_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
CREATE TABLE carejoy.rpm_fitbittoken
(
  id bigint NOT NULL DEFAULT nextval('carejoy.rpm_fitbittoken_seq'::regclass),
  access_token character varying(255),
  created_date timestamp with time zone,
  expiration_time timestamp with time zone,
  fitbit_user_id character varying(255),
  modified_date timestamp with time zone,
  refresh_token character varying(255),
  scope character varying(255),
  patient_device_id bigint,
  CONSTRAINT rpm_fitbittoken_pkey PRIMARY KEY (id),
  CONSTRAINT fk9b4ji0n00601ol33snaw9cnb2 FOREIGN KEY (patient_device_id)
      REFERENCES carejoy.rpm_patientdevicemap (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- *************** Carejoy Billing ************ --

DROP SEQUENCE IF EXISTS carejoy.billing_pt_hc_activity_seq;
CREATE SEQUENCE carejoy.billing_pt_hc_activity_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
DROP TABLE IF EXISTS carejoy.billing_pt_hc_activity;
CREATE TABLE carejoy.billing_pt_hc_activity
(
  id bigint NOT NULL DEFAULT nextval('carejoy.billing_pt_hc_activity_seq'::regclass),
  patient_uuid uuid,
  domain character varying(255),
  name character varying(255),
  type character varying(255),
  notes character varying(1000),
  additional_notes character varying(1000),
  duration_in_minutes bigint,
  started_on timestamp with time zone,
  completed_on timestamp with time zone,
  performed_by bigint,
  CONSTRAINT billing_pt_hc_activity_pkey PRIMARY KEY (id),
  CONSTRAINT billing_pt_hc_activity_fkey FOREIGN KEY (performed_by)
        REFERENCES dynamo.dynamo_user (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

DROP SEQUENCE IF EXISTS carejoy.billing_claim_seq;
CREATE SEQUENCE carejoy.billing_claim_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

DROP TABLE IF EXISTS carejoy.billing_claim;  
CREATE TABLE carejoy.billing_claim
(
  	id bigint NOT NULL DEFAULT nextval('carejoy.billing_claim_seq'::regclass),
    code_for_billing character varying(255),
    generated_instant timestamp with time zone,
    exported_instant timestamp with time zone,
    patient_id bigint,
    status character varying(255),
    billing_period_start timestamp with time zone,
    billing_period_end timestamp with time zone,
    CONSTRAINT billing_claim_pkey PRIMARY KEY (id),
    CONSTRAINT billing_claim_fkey FOREIGN KEY (patient_id)
        REFERENCES carejoy.core_patient (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

DROP SEQUENCE IF EXISTS carejoy.billing_claim_activity_map_seq;
CREATE SEQUENCE carejoy.billing_claim_activity_map_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
 
DROP TABLE IF EXISTS carejoy.billing_claim_activity_map;   
CREATE TABLE carejoy.billing_claim_activity_map
(
  	id bigint NOT NULL DEFAULT nextval('carejoy.billing_claim_activity_map_seq'::regclass),
    created_instant timestamp with time zone,
    modified_instant timestamp with time zone,
    claim_id bigint,
    activity_id bigint,
    CONSTRAINT billing_claim_activity_map_pkey PRIMARY KEY (id),
    CONSTRAINT billing_claim_activity_map_fkey1 FOREIGN KEY (claim_id)
        REFERENCES carejoy.billing_claim (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT billing_claim_activity_map_fkey2 FOREIGN KEY (activity_id)
        REFERENCES carejoy.billing_pt_hc_activity (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

DROP SEQUENCE IF EXISTS carejoy.billing_patient_enrollment_seq;
CREATE SEQUENCE carejoy.billing_patient_enrollment_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

DROP TABLE IF EXISTS carejoy.billing_patient_enrollment; 
CREATE TABLE carejoy.billing_patient_enrollment
(
    id bigint NOT NULL DEFAULT nextval('carejoy.billing_patient_enrollment_seq'::regclass),
    program_name character varying(255),
    patient_id bigint,
    enrollment_begin_instant timestamp with time zone,
    enrollment_end_instant timestamp with time zone,
    created_instant timestamp with time zone,
    modified_instant timestamp with time zone,
    CONSTRAINT billing_patient_enrollment_pkey PRIMARY KEY (id),
    CONSTRAINT billing_claim_fkey FOREIGN KEY (patient_id)
        REFERENCES carejoy.core_patient (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);