package com.example.baseproject.api.accessor.system;

import jakarta.validation.constraints.NotBlank;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Validated
@ConfigurationProperties(prefix = "app.info")
public record SystemApiInfoProperties(
        @NotBlank String name,
        @NotBlank String version,
        @NotBlank String status) {}
