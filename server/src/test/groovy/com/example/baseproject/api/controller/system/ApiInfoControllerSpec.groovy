package com.example.baseproject.api.controller.system

import com.example.baseproject.api.domain.system.ApiInfo
import com.example.baseproject.api.domain.system.GetApiInfoUseCase
import io.github.micfabian.snappo.Comparisons
import io.github.micfabian.snappo.Snappo
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
    GetApiInfoUseCase getApiInfoUseCase = Stub() {
        execute() >> new ApiInfo('base-project-api', '0.1.0-SNAPSHOT', 'UP')
    }

    def 'returns API metadata from the use case'() {
        expect:
        mvc.perform(get('/api/info'))
                .andExpect(status().isOk())
                .andExpect(jsonPath('$.name').value('base-project-api'))
                .andExpect(jsonPath('$.version').value('0.1.0-SNAPSHOT'))
                .andExpect(jsonPath('$.status').value('UP'))
    }

    def 'matches the response snapshot'() {
        when:
        def response = mvc.perform(get('/api/info'))
                .andExpect(status().isOk())
                .andReturn()
                .response
                .contentAsString

        then:
        Snappo.expect(response, Comparisons.JSON)
    }
}
