package com.example.baseproject.api.controller.system;

import com.example.baseproject.api.domain.system.ApiInfo;

public record ApiInfoResponse(String name, String version, String status) {

    public static ApiInfoResponse from(ApiInfo apiInfo) {
        return new ApiInfoResponse(apiInfo.name(), apiInfo.version(), apiInfo.status());
    }
}
