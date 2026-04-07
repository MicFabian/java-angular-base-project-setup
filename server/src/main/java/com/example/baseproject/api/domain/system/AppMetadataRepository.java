package com.example.baseproject.api.domain.system;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AppMetadataRepository extends JpaRepository<AppMetadataEntry, String> {}
