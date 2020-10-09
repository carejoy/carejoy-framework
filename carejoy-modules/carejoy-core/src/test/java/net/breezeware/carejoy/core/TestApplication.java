package net.breezeware.carejoy.core;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
@PropertySources({ @PropertySource(value = { "classpath:test.properties" }) })
@EnableJpaRepositories(basePackages = { "net.breezeware.carejoy", "net.breezeware.dynamo" })
@EntityScan(basePackages = { "net.breezeware.carejoy", "net.breezeware.dynamo" })
@ComponentScan(basePackages = { "net.breezeware.carejoy", "net.breezeware.dynamo" })
public class TestApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        new TestApplication().configure(new SpringApplicationBuilder(TestApplication.class)).run(args);
    }

    @Bean
    public RestTemplate getRestTemplate(RestTemplateBuilder builder) {
        return builder.build();
    }
}