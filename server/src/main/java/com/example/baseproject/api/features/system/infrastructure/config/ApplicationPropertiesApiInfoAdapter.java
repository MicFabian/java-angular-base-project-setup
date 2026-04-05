package com.example.baseproject.api.features.system.infrastructure.config;

import com.example.baseproject.api.features.system.application.port.out.LoadApiInfoPort;
import com.example.baseproject.api.features.system.domain.ApiInfo;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class ApplicationPropertiesApiInfoAdapter implements LoadApiInfoPort {

    private final String applicationName;
    private final String applicationVersion;

    public ApplicationPropertiesApiInfoAdapter(
            @Value("${spring.application.name}") String applicationName,
            @Value("${app.version}") String applicationVersion) {
        this.applicationName = applicationName;
        this.applicationVersion = applicationVersion;
    }

    @Override
    public ApiInfo load() {
        return new ApiInfo(applicationName, applicationVersion, "UP");
    }
}
