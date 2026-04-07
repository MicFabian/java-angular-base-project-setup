package com.example.baseproject.api.features.system.application.usecase

import com.example.baseproject.api.features.system.application.port.out.LoadApiInfoPort
import com.example.baseproject.api.features.system.domain.ApiInfo
import spock.lang.Specification

class GetApiInfoUseCaseImplSpec extends Specification {

    def 'loads API info from the output port'() {
        given:
        def loadApiInfoPort = Mock(LoadApiInfoPort)
        def useCase = new GetApiInfoUseCaseImpl(loadApiInfoPort)
        def expected = new ApiInfo('base-project-api', '0.1.0-SNAPSHOT', 'UP')

        when:
        def result = useCase.execute()

        then:
        1 * loadApiInfoPort.load() >> expected
        result == expected
    }
}
