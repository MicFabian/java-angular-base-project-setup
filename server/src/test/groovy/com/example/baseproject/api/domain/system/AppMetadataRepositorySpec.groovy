package com.example.baseproject.api.domain.system

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.ImportAutoConfiguration
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest
import org.springframework.boot.flyway.autoconfigure.FlywayAutoConfiguration
import spock.lang.Specification

@DataJpaTest(properties = 'spring.jpa.hibernate.ddl-auto=validate')
@ImportAutoConfiguration(FlywayAutoConfiguration)
class AppMetadataRepositorySpec extends Specification {

    @Autowired
    AppMetadataRepository appMetadataRepository

    def 'loads seeded application metadata through JPA'() {
        expect:
        appMetadataRepository.findById('app.name').map(AppMetadataEntry::getMetadataValue).orElse(null) == 'base-project-api'
        appMetadataRepository.findById('app.version').map(AppMetadataEntry::getMetadataValue).orElse(null) == '0.1.0-SNAPSHOT'
        appMetadataRepository.findById('app.status').map(AppMetadataEntry::getMetadataValue).orElse(null) == 'UP'
    }
}
