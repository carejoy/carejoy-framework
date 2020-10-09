CREATE SCHEMA IF NOT EXISTS fitbit;

DROP SEQUENCE IF EXISTS fitbit.fitbit_carejoy_id_seq;
CREATE SEQUENCE fitbit.fitbit_carejoy_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE SEQUENCE fitbit.fitbit_carejoy_token_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE SEQUENCE fitbit.fitbit_carejoy_device_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE SEQUENCE fitbit.patient_activity_data_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE SEQUENCE fitbit.patient_heart_rate_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;


DROP TABLE IF EXISTS fitbit.fitbit_carejoy;
create table fitbit.fitbit_carejoy(
        id bigint NOT NULL DEFAULT nextval('fitbit.fitbit_carejoy_id_seq'::regclass),
        carejoy_device_id varchar(50),
	user_id bigint,
	created_date timestamp with time zone,
  	modified_date timestamp with time zone,
	CONSTRAINT fitbit_carejoy_pkey PRIMARY KEY (id),
	CONSTRAINT fitbit_carejoy_fkey FOREIGN KEY (user_id)
        REFERENCES dynamo.dynamo_user (id) MATCH SIMPLE
    	ON UPDATE NO ACTION ON DELETE NO ACTION
);



DROP TABLE IF EXISTS fitbit.fitbit_carejoy_token;
create table fitbit.fitbit_carejoy_token
(
	id bigint NOT NULL DEFAULT nextval('fitbit.fitbit_carejoy_token_id_seq'::regclass),
	fitbit_carejoy_id bigint,
  	access_token character varying(255),
	refresh_token character varying(255),
  	expiration_time timestamp with time zone,
	scope character varying(255),
  	fitbit_user_id character varying(255),
	created_date timestamp with time zone,
	modified_date timestamp with time zone,
  	CONSTRAINT fitbit_carejoy_token_pkey PRIMARY KEY (id),
  	CONSTRAINT fitbit_carejoy_token_fkey FOREIGN KEY (fitbit_carejoy_id)
      	REFERENCES fitbit.fitbit_carejoy (id) MATCH SIMPLE
      	ON UPDATE NO ACTION ON DELETE NO ACTION
);

DROP TABLE IF EXISTS fitbit.fitbit_carejoy_device;
create table fitbit.fitbit_carejoy_device(
        id bigint NOT NULL DEFAULT nextval('fitbit.fitbit_carejoy_device_id_seq'::regclass),
        fitbit_carejoy_id bigint,
        fitbit_user_id varchar(100), /* login id of Fitbit */
        mac_id varchar(100), /* MAC address*/
        device_version varchar(50),
        device_tracker varchar(50),
        battery varchar(50),
        battery_level int,
        last_sync timestamp with time zone, /*last time device was synched*/
        step_count INT NOT NULL,
	CONSTRAINT fitbit_carejoy_device_pkey PRIMARY KEY (id),
	CONSTRAINT fitbit_carejoy_device_fkey FOREIGN KEY (fitbit_carejoy_id)
      	REFERENCES fitbit.fitbit_carejoy (id) MATCH SIMPLE
      	ON UPDATE NO ACTION ON DELETE NO ACTION
);

DROP TABLE IF EXISTS fitbit.patient_activity_data;
create table fitbit.patient_activity_data(
        id bigint NOT NULL DEFAULT nextval('fitbit.patient_activity_data_id_seq'::regclass),
        fitbit_carejoy_id bigint,
        activity_date timestamp with time zone, /*date and time of fitbit data*/
        activity_steps INT, /*Actual step count*/
        created_date timestamp with time zone,
	modified_date timestamp with time zone,
	CONSTRAINT patient_activity_data_pkey PRIMARY KEY (id),
	CONSTRAINT patient_activity_data_fkey FOREIGN KEY (fitbit_carejoy_id)
      	REFERENCES fitbit.fitbit_carejoy (id) MATCH SIMPLE
      	ON UPDATE NO ACTION ON DELETE NO ACTION
);

DROP TABLE IF EXISTS fitbit.patient_heart_rate;
create table fitbit.patient_heart_rate(
        id bigint NOT NULL DEFAULT nextval('fitbit.patient_heart_rate_id_seq'::regclass),
        fitbit_carejoy_id bigint,
        heart_rate_date date,
        from_time int,
        to_time int,
        avg_value float,
	CONSTRAINT patient_heart_rate_pkey PRIMARY KEY (id),
	CONSTRAINT patient_heart_rate_fkey FOREIGN KEY (fitbit_carejoy_id)
      	REFERENCES fitbit.fitbit_carejoy (id) MATCH SIMPLE
      	ON UPDATE NO ACTION ON DELETE NO ACTION
);

insert into fitbit.fitbit_carejoy(carejoy_device_id, user_id, created_date, modified_date) values ('karthikfitbit', 1, NOW(), NOW());
