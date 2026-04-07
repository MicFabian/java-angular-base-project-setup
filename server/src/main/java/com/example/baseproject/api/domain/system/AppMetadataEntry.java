package com.example.baseproject.api.domain.system;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.OffsetDateTime;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@Table(name = "app_metadata")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class AppMetadataEntry {

    @Id
    @Column(name = "metadata_key", nullable = false, length = 100)
    private String metadataKey;

    @Column(name = "metadata_value", nullable = false, length = 255)
    private String metadataValue;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    public AppMetadataEntry(String metadataKey, String metadataValue, OffsetDateTime updatedAt) {
        this.metadataKey = metadataKey;
        this.metadataValue = metadataValue;
        this.updatedAt = updatedAt;
    }
}
