package com.example.baseproject.api.features.system.infrastructure.config;

import com.example.baseproject.api.features.system.application.port.in.GetApiInfoUseCase;
import com.example.baseproject.api.features.system.application.port.out.LoadApiInfoPort;
import com.example.baseproject.api.features.system.application.usecase.GetApiInfoUseCaseImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SystemFeatureConfiguration {

    @Bean
    GetApiInfoUseCase getApiInfoUseCase(LoadApiInfoPort loadApiInfoPort) {
        return new GetApiInfoUseCaseImpl(loadApiInfoPort);
    }
}
