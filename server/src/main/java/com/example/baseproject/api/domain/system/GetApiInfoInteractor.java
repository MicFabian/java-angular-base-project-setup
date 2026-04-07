package com.example.baseproject.api.domain.system;

import java.util.Objects;

public final class GetApiInfoInteractor implements GetApiInfoUseCase {

    private final LoadApiInfoAccessor loadApiInfoAccessor;

    public GetApiInfoInteractor(LoadApiInfoAccessor loadApiInfoAccessor) {
        this.loadApiInfoAccessor = Objects.requireNonNull(loadApiInfoAccessor);
    }

    @Override
    public ApiInfo execute() {
        return loadApiInfoAccessor.load();
    }
}
