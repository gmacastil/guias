package com.lite.cliente.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FacturaDTO {
    private Long id;
    private String numero;
    private LocalDate fechaEmision;
    private BigDecimal total;
    private Long clienteId;
    private String descripcion;
}
