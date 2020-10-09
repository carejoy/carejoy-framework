package net.breezeware.carejoy.core.entity;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.Period;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.PostLoad;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.google.gson.annotations.Expose;
import com.querydsl.core.annotations.PropertyType;
import com.querydsl.core.annotations.QueryType;

import net.breezeware.carejoy.core.dto.VitalDto;
import net.breezeware.dynamo.organization.entity.User;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Entity
@Table(name = "core_patient", schema = "carejoy")
public class Patient implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String ROLE_PATIENT = "PATIENT";

    @Expose
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_gen")
    @SequenceGenerator(name = "seq_gen", sequenceName = "core_patient_seq", schema = "carejoy", allocationSize = 1)
    @Getter
    @Setter
    private long id;

    /**
     * UUID assigned by the Carejoy application. It will be used to identify the
     * patient across different systems in Carejoy like graph DB and view DB
     * (relational DB).
     */
    @Column(name = "patient_uuid")
    @Getter
    @Setter
    private String patientUuid;

    /**
     * Dynamo User entity associated with this patient. The User entity contains
     * information required for authentication purposes, like username & password.
     */
    @OneToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @Getter
    @Setter
    private User user;

    /**
     * Dynamo organization to which this patient belongs to.
     */
    @Column(name = "organization_id")
    @Getter
    @Setter
    private long organizationId;

    @Column(name = "first_name")
    @Getter
    @Setter
    private String firstName;

    @Column(name = "last_name")
    @Getter
    @Setter
    private String lastName;

    @Column(name = "middle_initial")
    @Getter
    @Setter
    private String middleInitial;

    @Column(name = "full_name")
    @Getter
    @Setter
    private String fullName;

    @Column(name = "home_phone")
    @Getter
    @Setter
    private String homePhone;

    @Column(name = "work_phone")
    @Getter
    @Setter
    private String workPhone;

    @Column(name = "mobile_phone")
    @Getter
    @Setter
    private String mobilePhone;

    // FIXME: haven't created DB column
    @Transient
    @Getter
    @Setter
    private String email;

    @Getter
    @Setter
    private String gender;

    @Getter
    @Setter
    @Transient
    @QueryType(PropertyType.NUMERIC)
    private long age;

    /**
     * Will be deprecated soon.
     */
    @Getter
    @Setter
    private String dob;

    @Getter
    @Setter
    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Getter
    @Setter
    private String race;

    @Getter
    @Setter
    private String ethnicity;

    @Getter
    @Setter
    private boolean deceased;

    @Getter
    @Setter
    private String ssn;

    @Getter
    @Setter
    private String address1;

    @Getter
    @Setter
    private String address2;

    @Getter
    @Setter
    private String city;

    @Getter
    @Setter
    private String state;

    @Getter
    @Setter
    private String country;

    @Column(name = "external_patient_id")
    @Getter
    @Setter
    private String externalPatientId;

    @Column(name = "external_patient_source")
    @Getter
    @Setter
    private String externalPatientSource;

    @Column(name = "zip_code")
    @Getter
    @Setter
    private String zipcode;

    @Transient
    @Getter
    @Setter
    private String maritalStatus;

    @Transient
    @Getter
    @Setter
    private String smokingStatus;

    @Transient
    @Getter
    @Setter
    private String preferredlanguage;

    /**
     * Patient's most recent weight.
     */
    @Transient
    @Getter
    @Setter
    private VitalDto latestWeight;

    /**
     * Patient's most recent blood pressure.
     */
    @Transient
    @Getter
    @Setter
    private VitalDto latestBloodPressure;

    /**
     * Patient's most recent blood glucose.
     */
    @Transient
    @Getter
    @Setter
    private VitalDto latestBloodGlucose;

    /**
     * Patient's most recent heart rate.
     */
    @Transient
    @Getter
    @Setter
    private VitalDto latestHeartRate;

    @PostLoad
    private void patientPostLoad() {

        if (dateOfBirth != null) {
            // this.age = LocalDate.now().getYear() - dateOfBirth.getYear();

            Period intervalPeriod = Period.between(dateOfBirth, LocalDate.now());
            long years = intervalPeriod.getYears();
            this.age = years;
        } else {
            this.age = 0;
        }
    }
}