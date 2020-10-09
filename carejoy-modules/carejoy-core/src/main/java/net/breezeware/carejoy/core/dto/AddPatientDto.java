package net.breezeware.carejoy.core.dto;

import java.time.LocalDate;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class AddPatientDto {

    @NotNull
    @Size(min = 1, max = 90, message = "{Size.addPatientDto.firstName}")

    private String firstName;

    private String middleInitial;

    @NotNull(message = "Last name cannot be null")
    @Size(min = 1, max = 90, message = "{Size.addPatientDto.lastName}")

    private String lastName;

    /**
     * Gender - Male/Female
     */
    @NotNull(message = "{NotNull.addPatientDto.gender}")

    private String gender;

    /**
     * Date of Birth
     */
    @NotNull(message = "{NotNull.addPatientDto.dateOfBirth}")

    @DateTimeFormat(pattern = "MM-dd-yyyy")
    private LocalDate dateOfBirth;

    @Size(min = 0, max = 11, message = "{Size.addPatientDto.ssn}")

    private String ssn;

    // GRAPH telecom
    @Size(min = 6, max = 45, message = "{Size.addPatientDto.email}")
    @Pattern(regexp = ".+@.+\\..+", message = "{Pattern.addPatientDto.email}")

    private String email;

    // GRAPH telecom
    @NotNull
    @Size(min = 4, max = 45, message = "{Size.addPatientDto.phoneNumber}")
    private String phoneNumber;

    // @NotNull
    // @Size(min = 5, max = 90, message = "{Size.addPatientDto.address1}")

    private String address1;

    private String address2;

    // @NotNull
    // @Size(min = 2, max = 45,message =
    // "{Size.addPatientDto.state}")

    private String state;

    // @NotNull
    // @Size(min = 2, max = 45, message =
    // "{Size.addPatientDto.city}")

    private String city;

    // @NotNull
    // @Size(min = 2, max = 45, message =
    // "{Size.addPatientDto.pincode}")

    private String pincode;

    private String race;

    private String ethnicity;

    private String language;

    private String smokingStatus;

    // GRAPH-TBD

    private String education;

    // GRAPH-TBD

    private String occupation;

    private String maritalStatus;

    // GRAPH-TBD
    // FIXME: not stored in RDBMS aswell

    private String numberOfChildren;

    private String diet;
}