package com.example.baseproject.api.controller.system;

import com.example.baseproject.api.domain.system.ApiInfo;
import com.example.baseproject.api.domain.system.GetApiInfoUseCase;
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
        return ApiInfoResponse.from(apiInfo);
    }
}
