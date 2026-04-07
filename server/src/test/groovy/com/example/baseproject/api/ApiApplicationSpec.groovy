package com.example.baseproject.api

import com.example.baseproject.api.controller.system.ApiInfoController
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.ApplicationContext
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
