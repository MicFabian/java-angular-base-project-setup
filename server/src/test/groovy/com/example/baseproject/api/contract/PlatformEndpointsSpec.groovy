package com.example.baseproject.api.contract

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc
import org.springframework.test.web.servlet.MockMvc
import spock.lang.Specification

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@SpringBootTest
@AutoConfigureMockMvc
class PlatformEndpointsSpec extends Specification {

    @Autowired
    MockMvc mvc

    def 'exposes readiness and liveness probes on the main server port'() {
        expect:
        mvc.perform(get('/actuator/health/liveness'))
                .andExpect(status().isOk())

        mvc.perform(get('/actuator/health/readiness'))
                .andExpect(status().isOk())
    }

    def 'publishes OpenAPI docs and actuator info'() {
        expect:
        mvc.perform(get('/v3/api-docs'))
                .andExpect(status().isOk())
                .andExpect(jsonPath('$.openapi').exists())

        mvc.perform(get('/actuator/info'))
                .andExpect(status().isOk())
                .andExpect(jsonPath('$.app.name').value('base-project-api'))
                .andExpect(jsonPath('$.app.version').value('0.1.0-SNAPSHOT'))
    }

    def 'publishes actuator discovery links for health and info'() {
        expect:
        mvc.perform(get('/actuator'))
                .andExpect(status().isOk())
                .andExpect(jsonPath('$._links.health.href').exists())
                .andExpect(jsonPath('$._links.info.href').exists())
    }
}
