package com.lite.cliente.infrastructure.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.lite.cliente.domain.dto.FacturaDTO;

import java.util.List;

@FeignClient(name = "factura-service", url = "${factura.service.url}")
public interface FacturaFeignClient {
    
    @GetMapping("/api/facturas/cliente/{clienteId}")
    List<FacturaDTO> getFacturasByClienteId(@PathVariable("clienteId") Long clienteId);
}
