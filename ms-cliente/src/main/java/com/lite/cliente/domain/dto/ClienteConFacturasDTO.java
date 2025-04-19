package com.lite.cliente.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClienteConFacturasDTO {
    private ClienteDTO cliente;
    private List<FacturaDTO> facturas;
}
