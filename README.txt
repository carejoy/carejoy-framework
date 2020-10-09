
Carejoy Release Notes- Healthcare Platform built on top of Dynamo Framework.

v 2.4.0:
-------
* Refactored RPM program progress calculation logic for performance improvements.

v 2.3.1:
-------
* Fixed issue where duplicate vocab items were created during Patient Enrollment and PGHD sync.

v 2.2.1:
-------
* Fixed the logic error that resulted in Stack Overflow error while retrieving latest claim for a billing period.

v 2.2.0:
-------
* Added services in billing module to retrieve a patient's progress in the program enrollment context.
* Added graph services to retrieve a patient's latest BG, BP, HR and Weight.

v 2.1.0:
-------
* Updated to Dynamo Framework version 1.7.0
* Removed Cadence dependency
* Removed RPM module
* Added support for Patient enrolment in Refresh Health
* Added User reference within Core Patient entity

v 2.0.0:
-------
* Updated to Dynamo Framework version 1.6.1
* Updated to Cadence Framework version 0.5.1
* Added Billing module for supporting claims generation for RPM codes: 99453, 99454, 99457, 99458, 99091
* Added REST API endpoints to retrieve patient details and patient's monthly vitals information

v1.9.0:
-------
* Updated to Dynamo Framework version 1.6.0

v1.8.0:
-------
* Added Billing module to manage patient Healthcare activities, coding and billing.
* Moved Patient entity and services from Patient Registry to Core module.
* Added services to record healthcare activities related to new patient addition and PGHD device assignment.
* Added services to render snapshot view of PGHD data.
* Added services to determine bill eligibility for certain CPT codes based on patient healthcare activities.

v1.7.1:
--------
* Added support to store Heart Rate / Pulse data from BodyTrace BP data feed

v1.7.0:
--------
* Disabled Fitbit and iHealth support
* Disabled rule engine invocation from Patient Registry service
* Disabled references to Apelon terminology server
* Added support to retrieve and display patient demographics info in patient's PGHD data view with graphs


v1.6.0:
--------
* Updated code to support OpenJDK 13.
* Updated Dynamo Framework version from 1.4.0 to 1.5.0
* Updated Cadence Framework version from 0.3.0 to 0.4.0
* Updated Cadence Framework version from 0.3.0 to 0.4.0

v1.5.0:
--------
* Added a new module 'EHR' for integrating data from external Electronic Health Records.
* Added support for retrieving data from AthenaHealth EHR's sandbox. Functionality to search EHR patients and import their records as CCDA documents are included.
* Extended PGHD module to support iGlucose glucometer, BodyTrace BP monitor, BodyTrace weighing scale and, Carejoy ODM devices.
* Added support to receive PGHD data from Carejoy Android application with OAuth2 authentication.

v1.4.0:
--------
* Added a new module 'PGHD' for managing Patient Generated Health Data.
* Added support for getting data from Fitbit Steps Tracker and iHealth Glucometer and Blood Pressure Monitor.
* Added support to display PGHD data for a patient as Observations in the Patient Record.	

v1.3.0:
--------
* Added a new module 'Patient Registry' and moved back end code related to Patient list from Carejoy Webapp project.
* Renamed 'Carejoy Domain' module to 'Carejoy Graph'. Non-graph entities are moved out from this renamed module to other 
	appropriate modules.
* Updated unit tests in Graph and CCDA modules to cover multiple use cases.	

v1.2.0:
--------
* Added support for Carejoy iOS mobile application.
* Added support for iOS mobile users to sync their Fitbit data with Carejoy web application. Functionality to view the 
	synced Fitbit data within web application will be added in the upcoming release.

v1.1.0:
--------
* Added functionality to store FHIR data in JSON format.
* Added functionality to parse and store FHIR PlanDefinition resource using HAPI FHIR library.
* Added functionality to select and assign a FHIR PlanDefinition resource to a patient.
* Added functionality to generate a FHIR CarePlan and related resources for a Patient based on a PlanDefinition.
* Integrated programatically generated CarePlan artifacts in Neo4J graph DB for further processing.
* Displayed CarePlan goals and activities for a patient in Consolidated View.

v1.0.0:
--------
* Updated Dynamo framework version to 1.2.0.
* Integrated front-end changes in Dynamo Framework into the web application.
* Carejoy web application has 4 clinical modules (FHIR, Patient Registry, Questionnaire, CCDA) and 2 management modules (User Management, Audit).
* Carejoy admin web application has 2 management modules (User Management, Audit).

v0.11.0:
--------
* Updated Dynamo framework version to 1.1.0. Front-end changes in Dynamo framework are not incorporated yet. It will be done in the next Carejoy framework release.

v0.10.0:
--------
* Refactored Carejoy system into two web applications: Carejoy Admin Webapp and Carejoy Webapp.
* Carejoy Admin Webapp can be used by account administrators to manage users, audit logs and configurations.
* Carejoy Webapp will have healthcare domain specific functionalities like FHIR, Questionnaire, CCDA, Patient Management etc...
* Followed CEHRT certification criteria to enable auditing and security features within the application.
* Added a simple Clinical Decision Support functionality while viewing a patient record. Diabetes guidelines implemented in Drools language provides this CDS functionality.</li>

v0.8.1:
-------
* Fixed various parsing issues in CCDA sections.
* Enhanced the Organize cycle (in AORTIS) work flow to handle additional scenarios.

v0.8.0:
-------
* Added functionality to preview a CCD file upload before storing it in the graph DB.
* Added consolidated view to display a patient's medical record. Consolidated view can display data gathered and
   integrated from multiple CCDA files. Data integration currently involves Aggregation(A) & Organization(O) cycles in the 
   AORTIS workflow. Reduction(R)/Transformation(T), Inference(I) and Synthesize(S) cycles will be covered in the 
   upcoming releases.
* Implemented patient matching logic to compare patient data in CCDA files with existing patients in the DB. This logic 
	is a part of the data integration workflow.   

v0.7.0:
-------
* Added functionality to upload CCD (Continuity of Care Document) CCDA file..
* Added functionality to parse 9 sections in CCD document. Sections are: Demographics, Allergies, 
	Conditions/Problems, Diagnostic Reports, Family History, Immunizations, Medications, Procedures, Vital Signs).
* Added support to persist CCD data in a graph DB (Neo4J).
* Added support to view CCD data stored in the graph DB (Neo4J).

v0.6.0:
-------
* Refactored code artifacts to remove references to Tulasi. The project will be called Carejoy and not Tulasi Carejoy.
* Updated to Dynamo version 0.4.1.
* Marked all service layer methods (considered 'events') for auditing based on Dynamo's Audit module. Calls to these methods along with input and output data 
	will be captured in the DB for auditing purposes.
* Carejoy entities will be managed in a separate DB schema 'Carejoy'. Dynamo entities are managed in the 'Dynamo' schema.

v0.4.3:
-------
* Refactored application to use multi-module Maven project strucutre for core, KB, FHIR, questionnaire and webapp modules.
* Developed a starter version of CCM eligibility rule (inside KB module )and integrated it with the patient list in webapp module.

v0.4.1:
-------
* Updated application to use the latest Dynamo framework v0.1.1
* Updated HTML to use Thymeleaf 3.0.3-RELEASE and Bootstrap v4.
* Added pagination support to Questionnaire session list page.

v0.3.0:
-------
* Updated to use Dynamo framework v0.1.0

v0.0.3:
-------
* Updated application to use the latest Dynamo framework v0.0.1-SNAPSHOT.
* Added support to access rules from remote KIE Execution server.
* Added support to access rules from KJARs added as application dependencies.

v0.0.2:
-------
* Import Patient FHIR resources in JSON format from OpenEPIC and Cerner FHIR sandboxes.
* Store FHIR resources in FHIRBase DB tables.
* Browse FHIRBase resources and view details in JSON format.
* Load Hypertension questionnaire, a DROOLS DRL file containing TOHU custom extensions.
* Execute Hypertension questionnaire using TOHU execution server.
* Store TOHU questionnaire sessions with answers in DB tables.
* Browse TOHU questionnaire sessions and view details.
