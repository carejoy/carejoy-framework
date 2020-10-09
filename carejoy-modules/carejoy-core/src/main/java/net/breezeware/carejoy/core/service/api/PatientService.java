package net.breezeware.carejoy.core.service.api;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.querydsl.core.types.Predicate;

import net.breezeware.carejoy.core.dto.AddPatientDto;
import net.breezeware.carejoy.core.entity.Patient;

public interface PatientService {

    /**
     * Retrieve all patients in the application taking into consideration the sort,
     * page and filter criteria.
     * 
     * @param predicate Filtering criteria.
     * @param pageable  Paging and Sorting criteria.
     * 
     * @return Page of patients.
     * 
     */
    Page<Patient> retrievePatients(Predicate predicate, Pageable pageable);

    /**
     * Retrieve a single patient by his UUID.
     * 
     * @param patientUuid UUID to uniquely identify the Patient.
     * @return Patient entity if a unique record exists else null.
     */
    Optional<Patient> retrievePatientByUuid(UUID patientUuid);

    /**
     * Retrieve a Patient entity by the user name of the User entity associated with
     * the patient.
     * 
     * @param username
     * @return Patient if a patient with user name found, else empty.
     */
    Optional<Patient> retrievePatientByUsername(String username);

    /**
     * check's paitient is already exist.
     * 
     * @param addPatientDto
     * @return
     */
    boolean doesPatientExist(AddPatientDto addPatientDto);

    /**
     * Checks whether the given email is registered for any user
     * 
     * @param email
     * @return boolean (registered or not)
     */
    boolean doesEmailRegisteredForAnyUser(String email);

    /**
     * Create a new patient entry and user in the registry.
     * 
     * @param addPatientDto
     * @param organizationId
     * @return
     * @throws Exception
     */
    Patient createPatientAndUser(AddPatientDto addPatientDto, long organizationId) throws Exception;
}