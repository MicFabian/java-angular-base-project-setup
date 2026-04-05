package com.example.baseproject.api

import com.example.baseproject.api.features.system.presentation.rest.ApiInfoController
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.ApplicationContext
import org.springframework.boot.test.context.SpringBootTest
import spock.lang.Specification

@SpringBootTest
class ApiApplicationSpec extends Specification {

    @Autowired
    ApplicationContext applicationContext

    def 'context loads the API controller'() {
        expect:
        applicationContext.getBean(ApiInfoController) != null
    }
}
