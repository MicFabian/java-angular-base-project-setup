package com.example.baseproject.api.domain.system;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class GetApiInfoUseCase {

    private static final String APP_NAME_KEY = "app.name";
    private static final String APP_VERSION_KEY = "app.version";
    private static final String APP_STATUS_KEY = "app.status";

    private final AppMetadataRepository appMetadataRepository;

    public ApiInfo execute() {
        return new ApiInfo(
                loadRequiredValue(APP_NAME_KEY), loadRequiredValue(APP_VERSION_KEY), loadRequiredValue(APP_STATUS_KEY));
    }

    private String loadRequiredValue(String key) {
        return appMetadataRepository
                .findById(key)
                .map(AppMetadataEntry::getMetadataValue)
                .orElseThrow(() -> new IllegalStateException("Missing application metadata for key: " + key));
    }
}
