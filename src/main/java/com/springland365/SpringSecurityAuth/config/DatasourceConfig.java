package com.springland365.SpringSecurityAuth.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseBuilder;

import javax.sql.DataSource;

import static org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseType.H2;

@Configuration
public class DatasourceConfig {

    @Bean
    public DataSource datasource()
    {
        return new EmbeddedDatabaseBuilder()
                .setType(H2)
                .build();
    }
}
