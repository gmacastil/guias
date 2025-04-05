package com.lite.factura.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Factura {
    private Long id;
    private String numero;
    private LocalDate fechaEmision;
    private BigDecimal total;
    private Long clienteId;
    private String descripcion;
}
