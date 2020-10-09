CREATE SCHEMA IF NOT EXISTS cadence; 

DROP SEQUENCE IF EXISTS cadence.device_seq;
CREATE SEQUENCE cadence.device_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;  
  
DROP SEQUENCE IF EXISTS cadence.device_category_state_seq;
CREATE SEQUENCE cadence.device_category_state_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;  
  
DROP TABLE IF EXISTS cadence.device_category;
CREATE TABLE cadence.device_category
(
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  name character varying(45),
  description character varying(180),
  is_special_category boolean,
  CONSTRAINT device_category_pkey PRIMARY KEY (name)
);

DROP TABLE IF EXISTS cadence.device_location;
CREATE TABLE cadence.device_location
(
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  name character varying(45),
  type character varying(45),
  CONSTRAINT device_location_pkey PRIMARY KEY (name)
); 

DROP TABLE IF EXISTS cadence.device;
CREATE TABLE cadence.device
(
  id bigint NOT NULL DEFAULT nextval('cadence.device_seq'::regclass),
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  name character varying(45),
  reference_name character varying(45),
  scada_name character varying(90),
  mac_address character varying(45),
  device_version character varying(45),
  serial_number character varying(45),
  software_version character varying(45),
  category_name character varying(45),
  location_name character varying(45),
  CONSTRAINT device_pkey PRIMARY KEY (id),
  CONSTRAINT device_fkey1 FOREIGN KEY (category_name)
      REFERENCES cadence.device_category (name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT device_fkey2 FOREIGN KEY (location_name)
      REFERENCES cadence.device_location (name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

DROP TABLE IF EXISTS cadence.device_category_state;
CREATE TABLE cadence.device_category_state
(
  id bigint NOT NULL DEFAULT nextval('cadence.device_category_state_seq'::regclass),
  created_date timestamp with time zone,
  modified_date timestamp with time zone,
  status character varying(90),
  control_action character varying(90),
  category_name character varying(45),
  CONSTRAINT device_category_state_pkey PRIMARY KEY (id),
  CONSTRAINT device_category_state_fkey FOREIGN KEY (category_name)
      REFERENCES cadence.device_category (name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Insert Statements(Sample Data) --
INSERT INTO cadence.device_category (name, description, is_special_category, created_date, modified_date) VALUES ('Field Access Controller','To Permit entry to field assets','false',now(), now());
INSERT INTO cadence.device_category (name, description, is_special_category, created_date, modified_date) VALUES ('Gate Access Controller','To Permit entry into the organization','false',now(), now());
INSERT INTO cadence.device_category (name, description, is_special_category, created_date, modified_date) VALUES ('Digi Lock','To SafeGuard Digital Assets','false',now(), now());
INSERT INTO cadence.device_location (name, type, created_date, modified_date) VALUES ('Griffin Site','Tower Security',now(), now());
INSERT INTO cadence.device_location (name, type, created_date, modified_date) VALUES ('Robo Site','Vero Robotics',now(), now());
INSERT INTO cadence.device_location (name, type, created_date, modified_date) VALUES ('Cannibis Site','Refresh Health',now(), now());
INSERT INTO cadence.device (id, name, reference_name, mac_address, serial_number, software_version, category_name, location_name, created_date, modified_date) VALUES (1, 'Field Asset', 'Field Controller', '77:7E:FG:5D:66:7G', '6755233550', 'v1.5', 'Field Access Controller', 'Griffin Site',now(), now());
INSERT INTO cadence.device (id, name, reference_name, mac_address, serial_number, software_version, category_name, location_name, created_date, modified_date) VALUES (2, 'Digital Locker', 'Digital Locker', '56:ED:7F:D3:DD:51', '2344322344', 'v1.1', 'Digi Lock', 'Cannibis Site',now(), now());
INSERT INTO cadence.device (id, name, reference_name, mac_address, serial_number, software_version, category_name, location_name, created_date, modified_date) VALUES (3, 'Security System', 'Security System', '66:ED:45:FH:54:98', '1234567890', 'v1.0', 'Gate Access Controller', 'Robo Site',now(), now());
INSERT INTO cadence.device_category_state(id, status, control_action, category_name, created_date, modified_date) VALUES(1, 'Open', 'Opening the Entity', 'Gate Access Controller', now(), now());
INSERT INTO cadence.device_category_state(id, status, control_action, category_name, created_date, modified_date) VALUES(2, 'Close', 'Closing the Entity', 'Gate Access Controller', now(), now());

-- Update the sequence numbers after all the sample data inserts --
select setval('cadence.device_seq', (select max(id)+1 from cadence.device), false);
select setval('cadence.device_category_state_seq', (select max(id)+1 from cadence.device_category_state), false);
