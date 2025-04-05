package com.lite.factura.infrastructure.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.lite.factura.application.service.FacturaRepository;
import com.lite.factura.application.service.FacturaService;
import com.lite.factura.application.service.FacturaUseCase;

@Configuration
public class BeanConfiguration {
    
    @Bean
    public FacturaUseCase facturaUseCase(FacturaRepository facturaRepository) {
        return new FacturaService(facturaRepository);
    }
}
