package net.breezeware.carejoy.core;

import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.testng.Assert;
import org.testng.annotations.Test;

import com.querydsl.core.BooleanBuilder;

import lombok.extern.slf4j.Slf4j;
import net.breezeware.carejoy.core.dto.AddPatientDto;
import net.breezeware.carejoy.core.entity.Patient;
import net.breezeware.carejoy.core.entity.PatientUserMap;
import net.breezeware.carejoy.core.service.api.PatientService;

@ContextConfiguration(classes = TestApplication.class)
@Slf4j
public class PatientServiceTest extends AbstractTestNGSpringContextTests {

    @Autowired
    PatientService patientService;

    @Test
    public void createPatientTest() {
        log.info("Entering createPatientTest()");

        long organizationId = 2;
        AddPatientDto apd = new AddPatientDto();
        apd.setDay(19);
        apd.setFirstName("Bob");
        apd.setGender("Male");
        apd.setLastName("Marley");
        apd.setMiddleInitial("");
        apd.setMonth(1);
        apd.setSsn("1345");
        apd.setYear(1981);

        Patient patient;
        try {
            patient = patientService.createPatient(apd, organizationId);
            Assert.assertTrue(patient.getId() > 0);
        } catch (Exception e) {
            log.error("Exception occured. E = {}", e);
        }

        log.info("Leaving createPatientTest()");
    }

    @Test(dependsOnMethods = { "createPatientTest" })
    public void retrievePatientsTest() {
        log.info("Entering retrievePatientsTest()");

        // Pageable entity
        int page = 0;
        int size = 10;
        PageRequest pageRequest = PageRequest.of(page, size);

        try {
            Page<Patient> patientsPage = patientService.retrievePatients(new BooleanBuilder(), pageRequest);
            Assert.assertTrue(patientsPage.getTotalElements() > 0);
        } catch (Exception e) {
            log.error("Exception occured. E = {}", e);
        }

        log.info("Leaving retrievePatientsTest()");
    }

    @Test(dependsOnMethods = { "retrievePatientsTest" })
    public void retrievePatientByUuidTest() {
        log.info("Entering retrievePatientByUuidTest()");

        String patientUuid = "058a40a4-8638-4eb2-bd21-aaf2ad14fc0a";
        try {
            Optional<Patient> patientVal = patientService.retrievePatientByUuid(UUID.fromString(patientUuid));
            Assert.assertTrue(patientVal.isPresent());
        } catch (Exception e) {
            log.error("Exception occured. E = {}", e);
        }

        log.info("Leaving retrievePatientByUuidTest()");
    }

    @Test(dependsOnMethods = { "retrievePatientByUuidTest" })
    public void retrievePatientUserMapTest() {
        log.info("Entering retrievePatientUserMapTest()");

        String username = "n8iat5eck1JGMJyf2tOW";
        try {
            Optional<PatientUserMap> patientUserMapVal = patientService.retrievePatientUserMap(username);
            Assert.assertTrue(patientUserMapVal.isPresent());
        } catch (Exception e) {
            log.error("Exception occured. E = {}", e);
        }

        log.info("Leaving retrievePatientUserMapTest()");
    }

    @Test(dependsOnMethods = { "retrievePatientUserMapTest" })
    public void retrievePatientUserMapByPatientIdTest() {
        log.info("Entering retrievePatientUserMapByPatientIdTest()");

        String patientUuid = "058a40a4-8638-4eb2-bd21-aaf2ad14fc0a";
        try {
            Optional<PatientUserMap> patientUserMapVal = patientService
                    .retrievePatientUserMapByPatientId(UUID.fromString(patientUuid));
            Assert.assertTrue(patientUserMapVal.isPresent());
        } catch (Exception e) {
            log.error("Exception occured. E = {}", e);
        }

        log.info("Leaving retrievePatientUserMapByPatientIdTest()");
    }

}