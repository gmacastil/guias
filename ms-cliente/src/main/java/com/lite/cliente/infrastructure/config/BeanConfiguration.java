package com.lite.cliente.infrastructure.config;

import com.lite.cliente.application.service.ClienteRepository;
import com.lite.cliente.application.service.ClienteService;
import com.lite.cliente.application.service.ClienteUseCase;
import com.lite.cliente.infrastructure.feign.FacturaFeignClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class BeanConfiguration {
    
    @Bean
    public ClienteUseCase clienteUseCase(ClienteRepository clienteRepository, FacturaFeignClient facturaFeignClient) {
        return new ClienteService(clienteRepository, facturaFeignClient);
    }
}
