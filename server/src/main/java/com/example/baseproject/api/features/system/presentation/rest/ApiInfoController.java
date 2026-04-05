package com.example.baseproject.api.features.system.presentation.rest;

import com.example.baseproject.api.features.system.application.port.in.GetApiInfoUseCase;
import com.example.baseproject.api.features.system.domain.ApiInfo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ApiInfoController {

    private final GetApiInfoUseCase getApiInfoUseCase;

    public ApiInfoController(GetApiInfoUseCase getApiInfoUseCase) {
        this.getApiInfoUseCase = getApiInfoUseCase;
    }

    @GetMapping("/info")
    public ApiInfoResponse info() {
        ApiInfo apiInfo = getApiInfoUseCase.execute();
        return new ApiInfoResponse(apiInfo.name(), apiInfo.version(), apiInfo.status());
    }
}
