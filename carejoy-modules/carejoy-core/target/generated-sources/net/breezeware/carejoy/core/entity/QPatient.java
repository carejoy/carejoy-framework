package net.breezeware.carejoy.core.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QPatient is a Querydsl query type for Patient
 */
@Generated("com.querydsl.codegen.EntitySerializer")
public class QPatient extends EntityPathBase<Patient> {

    private static final long serialVersionUID = -87143335L;

    private static final PathInits INITS = PathInits.DIRECT2;

    public static final QPatient patient = new QPatient("patient");

    public final StringPath address1 = createString("address1");

    public final StringPath address2 = createString("address2");

    public final NumberPath<Long> age = createNumber("age", Long.class);

    public final StringPath city = createString("city");

    public final StringPath country = createString("country");

    public final DatePath<java.time.LocalDate> dateOfBirth = createDate("dateOfBirth", java.time.LocalDate.class);

    public final BooleanPath deceased = createBoolean("deceased");

    public final StringPath dob = createString("dob");

    public final StringPath ethnicity = createString("ethnicity");

    public final StringPath externalPatientId = createString("externalPatientId");

    public final StringPath externalPatientSource = createString("externalPatientSource");

    public final StringPath firstName = createString("firstName");

    public final StringPath fullName = createString("fullName");

    public final StringPath gender = createString("gender");

    public final StringPath homePhone = createString("homePhone");

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final StringPath lastName = createString("lastName");

    public final StringPath middleInitial = createString("middleInitial");

    public final StringPath mobilePhone = createString("mobilePhone");

    public final NumberPath<Long> organizationId = createNumber("organizationId", Long.class);

    public final StringPath patientUuid = createString("patientUuid");

    public final StringPath race = createString("race");

    public final StringPath ssn = createString("ssn");

    public final StringPath state = createString("state");

    public final net.breezeware.dynamo.organization.entity.QUser user;

    public final StringPath workPhone = createString("workPhone");

    public final StringPath zipcode = createString("zipcode");

    public QPatient(String variable) {
        this(Patient.class, forVariable(variable), INITS);
    }

    public QPatient(Path<? extends Patient> path) {
        this(path.getType(), path.getMetadata(), PathInits.getFor(path.getMetadata(), INITS));
    }

    public QPatient(PathMetadata metadata) {
        this(metadata, PathInits.getFor(metadata, INITS));
    }

    public QPatient(PathMetadata metadata, PathInits inits) {
        this(Patient.class, metadata, inits);
    }

    public QPatient(Class<? extends Patient> type, PathMetadata metadata, PathInits inits) {
        super(type, metadata, inits);
        this.user = inits.isInitialized("user") ? new net.breezeware.dynamo.organization.entity.QUser(forProperty("user"), inits.get("user")) : null;
    }

}

