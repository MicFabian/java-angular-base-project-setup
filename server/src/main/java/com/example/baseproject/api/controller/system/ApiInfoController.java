package com.example.baseproject.api.controller.system;

import com.example.baseproject.api.controller.system.resources.ApiInfoResponse;
import com.example.baseproject.api.domain.system.ApiInfo;
import com.example.baseproject.api.domain.system.GetApiInfoUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/info")
@RequiredArgsConstructor
public class ApiInfoController {

    private final GetApiInfoUseCase getApiInfoUseCase;

    @GetMapping
    public ApiInfoResponse info() {
        ApiInfo apiInfo = getApiInfoUseCase.execute();
        return new ApiInfoResponse(apiInfo.name(), apiInfo.version(), apiInfo.status());
    }
}
