package com.example.baseproject.api.features.system.application.usecase;

import com.example.baseproject.api.features.system.application.port.in.GetApiInfoUseCase;
import com.example.baseproject.api.features.system.application.port.out.LoadApiInfoPort;
import com.example.baseproject.api.features.system.domain.ApiInfo;

public class GetApiInfoUseCaseImpl implements GetApiInfoUseCase {

    private final LoadApiInfoPort loadApiInfoPort;

    public GetApiInfoUseCaseImpl(LoadApiInfoPort loadApiInfoPort) {
        this.loadApiInfoPort = loadApiInfoPort;
    }

    @Override
    public ApiInfo execute() {
        return loadApiInfoPort.load();
    }
}
