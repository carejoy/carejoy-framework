package net.breezeware.carejoy.core.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.querydsl.binding.QuerydslBinderCustomizer;
import org.springframework.data.querydsl.binding.QuerydslBindings;
import org.springframework.stereotype.Repository;

import com.querydsl.core.types.dsl.StringPath;

import net.breezeware.carejoy.core.entity.Patient;
import net.breezeware.carejoy.core.entity.QPatient;

@Repository
public interface CorePatientRepository
        extends JpaRepository<Patient, Long>, QuerydslPredicateExecutor<Patient>, QuerydslBinderCustomizer<QPatient> {

    List<Patient> findByPatientUuid(String patientUuid);

    List<Patient> findByOrganizationId(long organizationId);

    Patient findByUserUserUniqueIdIgnoreCase(String username);

    @Override
    default public void customize(QuerydslBindings bindings, QPatient qPatient) {
        bindings.bind(String.class).first((StringPath path, String value) -> path.containsIgnoreCase(value));
    }
}