package com.example.baseproject.api.config.system;

import com.example.baseproject.api.domain.system.ApiInfo;
import com.example.baseproject.api.domain.system.GetApiInfoUseCase;
import java.util.Map;
import org.springframework.boot.actuate.info.InfoContributor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
public class SystemConfiguration {

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
