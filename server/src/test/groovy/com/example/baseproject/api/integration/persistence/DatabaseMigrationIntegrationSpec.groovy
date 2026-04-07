package com.example.baseproject.api.integration.persistence

import com.example.baseproject.api.testsupport.container.PostgresContainerConfiguration
import javax.sql.DataSource
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Import
import org.springframework.jdbc.core.JdbcTemplate
import spock.lang.Specification

@SpringBootTest
@Import(PostgresContainerConfiguration)
class DatabaseMigrationIntegrationSpec extends Specification {

    @Autowired
    DataSource dataSource

    @Autowired
    JdbcTemplate jdbcTemplate

    def 'applies flyway migrations against postgres'() {
        def databaseProductName = dataSource.connection.withCloseable { connection ->
            connection.metaData.databaseProductName
        }

        expect:
        databaseProductName == 'PostgreSQL'
        jdbcTemplate.queryForObject(
                'select count(*) from flyway_schema_history where version = ? and success = true',
                Integer,
                '1'
        ) == 1
        jdbcTemplate.queryForObject(
                'select metadata_value from app_metadata where metadata_key = ?',
                String,
                'schema.baseline'
        ) == '1'
        jdbcTemplate.queryForObject(
                'select metadata_value from app_metadata where metadata_key = ?',
                String,
                'app.name'
        ) == 'base-project-api'
    }
}
