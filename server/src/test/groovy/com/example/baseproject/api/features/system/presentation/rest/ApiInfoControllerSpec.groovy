package com.example.baseproject.api.features.system.presentation.rest

import com.example.baseproject.api.features.system.application.port.in.GetApiInfoUseCase
import com.example.baseproject.api.features.system.domain.ApiInfo
import org.spockframework.spring.SpringBean
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest
import org.springframework.test.web.servlet.MockMvc
import spock.lang.Specification

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@WebMvcTest(ApiInfoController)
class ApiInfoControllerSpec extends Specification {

    @Autowired
    MockMvc mvc

    @SpringBean
    GetApiInfoUseCase getApiInfoUseCase = Mock()

    def 'returns service metadata'() {
        given:
        getApiInfoUseCase.execute() >> new ApiInfo('base-project-api', '0.1.0-SNAPSHOT', 'UP')

        expect:
        mvc.perform(get('/api/info'))
                .andExpect(status().isOk())
                .andExpect(jsonPath('$.name').value('base-project-api'))
                .andExpect(jsonPath('$.version').value('0.1.0-SNAPSHOT'))
                .andExpect(jsonPath('$.status').value('UP'))
    }
}
