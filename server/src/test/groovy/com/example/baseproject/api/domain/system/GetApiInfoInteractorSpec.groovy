package com.example.baseproject.api.domain.system

import spock.lang.Specification

class GetApiInfoInteractorSpec extends Specification {

    def 'loads API info from the accessor'() {
        given:
        def loadApiInfoAccessor = Mock(LoadApiInfoAccessor)
        def useCase = new GetApiInfoInteractor(loadApiInfoAccessor)
        def expected = new ApiInfo('base-project-api', '0.1.0-SNAPSHOT', 'UP')

        when:
        def result = useCase.execute()

        then:
        1 * loadApiInfoAccessor.load() >> expected
        result == expected
    }
}
