-- ********** NOTE ***********
-- Use the following SQL statements to setup additional roles relevant to 
-- Carejoy after a new organization is created in the DB.
-- In this case, organization_id is set to 3. 
-- Replace it appropriately. Rest of the values can remain the same.

INSERT INTO dynamo.role (organization_id, created_date, description, modified_date, name) VALUES
(7, now(), 'Organization User', now(), 'ORGANIZATION_USER');

INSERT INTO dynamo.role (organization_id, created_date, description, modified_date, name) VALUES
(7, now(), 'Careteam User', now(), 'CARETEAM_USER');

INSERT INTO dynamo.role (organization_id, created_date, description, modified_date, name) VALUES
(7, now(), 'Data Analyst', now(), 'DATA_ANALYST');

INSERT INTO dynamo.role (organization_id, created_date, description, modified_date, name) VALUES
(7, now(), 'Patient', now(), 'PATIENT');

INSERT INTO dynamo.role (organization_id, created_date, description, modified_date, name) VALUES
(7, now(), 'Clinician', now(), 'CLINICIAN');

INSERT INTO dynamo.dynamo_group (organization_id, created_date, description, modified_date, name) VALUES
(7, now(), 'Business', now(), 'Business');

INSERT INTO dynamo.dynamo_group (organization_id, created_date, description, modified_date, name) VALUES
(7, now(), 'Technical', now(), 'Technical');