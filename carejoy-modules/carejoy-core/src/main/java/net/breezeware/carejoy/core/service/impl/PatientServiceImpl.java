package net.breezeware.carejoy.core.service.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

import net.breezeware.carejoy.core.dao.CorePatientRepository;
import net.breezeware.carejoy.core.dto.AddPatientDto;
import net.breezeware.carejoy.core.entity.Patient;
import net.breezeware.carejoy.core.entity.QPatient;
import net.breezeware.carejoy.core.service.api.PatientService;
import net.breezeware.dynamo.audit.aspectj.Auditable;
import net.breezeware.dynamo.organization.entity.Organization;
import net.breezeware.dynamo.organization.entity.Role;
import net.breezeware.dynamo.organization.entity.User;
import net.breezeware.dynamo.organization.service.api.OrganizationService;
import net.breezeware.dynamo.util.exeption.DynamoDataAccessException;

@Service
public class PatientServiceImpl implements PatientService {

    Logger logger = LoggerFactory.getLogger(PatientServiceImpl.class);

    @Autowired
    private CorePatientRepository patientRepository;

    @Autowired(required = false)
    private OrganizationService organizationService;

    @Transactional
    @Auditable(event = "Retrieve Patients", argNames = "predicate, pageable")
    public Page<Patient> retrievePatients(Predicate predicate, Pageable pageable) {
        logger.info("Entering getPatients(). predicate = {}.  pageable = {}", predicate, pageable);

        Page<Patient> patientsPage = null;

        if (predicate == null) {
            patientsPage = patientRepository.findAll(pageable);
        } else {
            patientsPage = patientRepository.findAll(predicate, pageable);
        }

        logger.info("Leaving getPatients(). total # of patients  = {}", patientsPage.getTotalElements());

        return patientsPage;
    }

    @Transactional
    // @Auditable(event = "Retrieve Patient by UUID", argNames = "patientUuid")
    public Optional<Patient> retrievePatientByUuid(UUID patientUuid) {
        logger.info("Entering retrievePatientByUuid(). Patient UUID = {}", patientUuid);

        List<Patient> patientsWithUuid = patientRepository.findByPatientUuid(patientUuid.toString());

        if (patientsWithUuid != null && patientsWithUuid.size() == 1) {
            logger.info("Patient with UUID found. Return it.");
            return Optional.of(patientsWithUuid.get(0));
        } else if (patientsWithUuid != null && patientsWithUuid.size() > 1) {
            logger.info("Multiple patients with UUID found. Return NULL.");
            return Optional.ofNullable(null);
        } else {
            logger.info("No patient with UUID found. Return NULL.");
            return Optional.ofNullable(null);
        }
    }

    @Transactional
    @Auditable(event = "Retrieve Patient by Username", argNames = "patientUuid")
    public Optional<Patient> retrievePatientByUsername(String username) {
        logger.info("Entering retrievePatientByUsername(). username = {}", username);

        Patient patient = patientRepository.findByUserUserUniqueIdIgnoreCase(username);

        if (patient != null) {
            logger.debug("Patient with username found. Return it.");
            return Optional.of(patient);
        } else {
            logger.debug("No patient with username found. Return NULL.");
            return Optional.empty();
        }
    }

    /**
     * create a Dynamo User from AddPatientDto
     * @param addPatientDto
     * @param organizationId
     * @return <b>Dynamo User</b>
     * @throws DynamoDataAccessException
     */
    private User buildDynamoUserForPatient(AddPatientDto addPatientDto, long organizationId)
            throws DynamoDataAccessException {
        logger.info("Entering buildDynamoUserForPatient()");

        User user = new User();

        user.setFirstName(addPatientDto.getFirstName());
        user.setLastName(addPatientDto.getLastName());
        user.setMiddleInitial(addPatientDto.getMiddleInitial());
        user.setEmail(addPatientDto.getEmail());
        user.setPhoneNumber(addPatientDto.getPhoneNumber());

        Organization org = organizationService.findOrganizationById(organizationId);
        user.setOrganization(org);

        user.setPassword("refresh123");
        user.setUserUniqueId(addPatientDto.getEmail());
        user.setCreatedDate(Calendar.getInstance());
        user.setModifiedDate(Calendar.getInstance());
        user.setStatus(User.STATUS_NEW);

        // set Patient role for the user
        Optional<Role> patientRole = organizationService.findRoleByName(organizationId, Patient.ROLE_PATIENT);
        if (patientRole.isPresent()) {
            List<Long> roleIdList = new ArrayList<Long>();
            roleIdList.add(Long.valueOf(patientRole.get().getId()));
            user.setUserRoleId(roleIdList);
        }

        // FIXME: hard coded value currently set to New York.
        user.setUserTimeZoneId(User.userTimeZoneOptions().get(18));

        logger.info("Leaving buildDynamoUserForPatient()");
        return user;
    }

    /**
     * creates a Carejoy core Patient from AddPatientDto.
     * @param addPatientDto
     * @param organizationId
     * @return <b>Carejoy core Patient</b>
     */
    private Patient buildPatient(AddPatientDto addPatientDto, long organizationId) {
        logger.info("Entering buildPatient() ,addPatientDto {}", addPatientDto);

        Patient patient = new Patient();

        patient.setFirstName(addPatientDto.getFirstName());
        patient.setLastName(addPatientDto.getLastName());
        patient.setMiddleInitial(addPatientDto.getMiddleInitial());
        patient.setMobilePhone(addPatientDto.getPhoneNumber());
        patient.setGender(addPatientDto.getGender());
        patient.setDateOfBirth(addPatientDto.getDateOfBirth());
        patient.setEmail(addPatientDto.getEmail());

        patient.setRace(addPatientDto.getRace());
        patient.setEthnicity(addPatientDto.getEthnicity());
        patient.setDeceased(false);
        // patient.setAge(0);
        patient.setSsn(addPatientDto.getSsn());
        patient.setAddress1(addPatientDto.getAddress1());
        patient.setAddress2(addPatientDto.getAddress2());
        patient.setCity(addPatientDto.getCity());
        patient.setState(addPatientDto.getState());
        patient.setCountry("USA");
        patient.setZipcode(addPatientDto.getPincode());

        patient.setPatientUuid(UUID.randomUUID().toString());
        patient.setOrganizationId(organizationId);
        patient.setFullName(addPatientDto.getFirstName() + " " + addPatientDto.getLastName());

        logger.info("Leaving buildPatient(), patient {}", patient);
        return patient;
    }

    public boolean doesPatientExist(AddPatientDto addPatientDto) {
        logger.info("Entering doesPatientExist(). AddPatientDto = {}", addPatientDto);

        boolean doesPatientExist = false;

        // build filter
        BooleanBuilder bb = new BooleanBuilder();
        bb.and(QPatient.patient.firstName.equalsIgnoreCase(addPatientDto.getFirstName()));
        bb.and(QPatient.patient.lastName.equalsIgnoreCase(addPatientDto.getLastName()));
        bb.and(QPatient.patient.gender.equalsIgnoreCase(addPatientDto.getGender()));
        bb.and(QPatient.patient.dateOfBirth.eq(addPatientDto.getDateOfBirth()));

        // check existing list
        List<Patient> existingPatients = (List<Patient>) patientRepository.findAll(bb);
        if (existingPatients != null && existingPatients.size() > 0) {
            doesPatientExist = true;
        }

        logger.info("Leaving doesPatientExist()");

        return doesPatientExist;
    }

    public boolean doesEmailRegisteredForAnyUser(String email) {
        boolean isRegistered = false;

        User user = organizationService.findByEmailIgnoreCase(email);

        if (user != null) {
            isRegistered = true;
        }

        return isRegistered;
    }

    @Transactional
    public Patient createPatientAndUser(AddPatientDto addPatientDto, long organizationId) throws Exception {
        logger.info("Entering createPatient(). AddPatientDto = {}. Organization Id = {}", addPatientDto,
                organizationId);

        Patient patient = null;

        // determine if a patient with given details already exits
        boolean doesPatientExist = doesPatientExist(addPatientDto);
        logger.info("Does Patient exist with details? = {}", doesPatientExist);

        // create a new patient only if it does not exist
        if (doesPatientExist) {
            throw new Exception("Patient with given details already exists!. Please update the details and try again.");
        } else {
            // create an organization user
            User dynamoUser = buildDynamoUserForPatient(addPatientDto, organizationId);
            dynamoUser = organizationService.createUser(dynamoUser);

            // build patient from DTO and persist it
            patient = buildPatient(addPatientDto, organizationId);
            patient.setUser(dynamoUser);
            patient = patientRepository.save(patient);

            // // create a mapping between patient and user
            // PatientUserMap puMap = new PatientUserMap();
            // puMap.setPatientUuid(UUID.fromString(patient.getPatientUuid()));
            // puMap.setUserId(dynamoUser.getId());
            // puMap.setCreatedDate(Instant.now());
            // patientUserMapRepository.save(puMap);
        }
        return patient;
    }
}