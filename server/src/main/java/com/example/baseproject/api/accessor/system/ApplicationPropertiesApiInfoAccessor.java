package com.example.baseproject.api.accessor.system;

import com.example.baseproject.api.domain.system.ApiInfo;
import com.example.baseproject.api.domain.system.LoadApiInfoAccessor;
import java.util.Objects;

public final class ApplicationPropertiesApiInfoAccessor implements LoadApiInfoAccessor {

    private final SystemApiInfoProperties apiInfoProperties;

    public ApplicationPropertiesApiInfoAccessor(SystemApiInfoProperties apiInfoProperties) {
        this.apiInfoProperties = Objects.requireNonNull(apiInfoProperties);
    }

    @Override
    public ApiInfo load() {
        return new ApiInfo(apiInfoProperties.name(), apiInfoProperties.version(), apiInfoProperties.status());
    }
}
