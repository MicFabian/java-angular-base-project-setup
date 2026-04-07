package com.example.baseproject.api.domain.system

import java.time.OffsetDateTime
import java.util.Optional
import spock.lang.Specification

class GetApiInfoUseCaseSpec extends Specification {

    def 'loads API info from the repository'() {
        given:
        def appMetadataRepository = Mock(AppMetadataRepository)
        def useCase = new GetApiInfoUseCase(appMetadataRepository)
        def now = OffsetDateTime.parse('2026-04-07T00:00:00Z')

        when:
        def result = useCase.execute()

        then:
        1 * appMetadataRepository.findById('app.name') >> Optional.of(new AppMetadataEntry('app.name', 'base-project-api', now))
        1 * appMetadataRepository.findById('app.version') >> Optional.of(new AppMetadataEntry('app.version', '0.1.0-SNAPSHOT', now))
        1 * appMetadataRepository.findById('app.status') >> Optional.of(new AppMetadataEntry('app.status', 'UP', now))
        result == new ApiInfo('base-project-api', '0.1.0-SNAPSHOT', 'UP')
    }
}
