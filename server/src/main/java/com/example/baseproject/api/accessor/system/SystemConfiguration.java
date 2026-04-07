package com.example.baseproject.api.accessor.system;

import com.example.baseproject.api.domain.system.ApiInfo;
import com.example.baseproject.api.domain.system.GetApiInfoInteractor;
import com.example.baseproject.api.domain.system.GetApiInfoUseCase;
import com.example.baseproject.api.domain.system.LoadApiInfoAccessor;
import java.util.Map;
import org.springframework.boot.actuate.info.InfoContributor;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
@EnableConfigurationProperties(SystemApiInfoProperties.class)
public class SystemConfiguration {

    @Bean
    LoadApiInfoAccessor loadApiInfoAccessor(SystemApiInfoProperties apiInfoProperties) {
        return new ApplicationPropertiesApiInfoAccessor(apiInfoProperties);
    }

    @Bean
    GetApiInfoUseCase getApiInfoUseCase(LoadApiInfoAccessor loadApiInfoAccessor) {
        return new GetApiInfoInteractor(loadApiInfoAccessor);
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
