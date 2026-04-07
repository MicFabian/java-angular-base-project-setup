package com.example.baseproject.api.features.system.infrastructure.config;

import com.example.baseproject.api.features.system.application.port.in.GetApiInfoUseCase;
import com.example.baseproject.api.features.system.application.port.out.LoadApiInfoPort;
import com.example.baseproject.api.features.system.application.usecase.GetApiInfoUseCaseImpl;
import com.example.baseproject.api.features.system.domain.ApiInfo;
import java.util.Map;
import org.springframework.boot.actuate.info.InfoContributor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SystemFeatureConfiguration {

    @Bean
    GetApiInfoUseCase getApiInfoUseCase(LoadApiInfoPort loadApiInfoPort) {
        return new GetApiInfoUseCaseImpl(loadApiInfoPort);
    }

    @Bean
    InfoContributor apiInfoContributor(GetApiInfoUseCase getApiInfoUseCase) {
        return (builder) -> {
            ApiInfo apiInfo = getApiInfoUseCase.execute();
            builder.withDetail(
                    "app",
                    Map.of(
                            "name", apiInfo.name(),
                            "version", apiInfo.version(),
                            "status", apiInfo.status()));
        };
    }
}
