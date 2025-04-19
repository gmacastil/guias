package com.lite.cliente.domain.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ClienteDTO {
    private Long id;
    
    @NotEmpty(message = "El nombre no puede estar vacío")
    private String nombre;
    
    @NotEmpty(message = "El apellido no puede estar vacío")
    private String apellido;
    
    @NotEmpty(message = "El documento no puede estar vacío")
    private String documento;
    
    @NotEmpty(message = "El teléfono no puede estar vacío")
    @Pattern(regexp = "\\d{10}", message = "El teléfono debe tener 10 dígitos")
    private String telefono;
    
    @NotEmpty(message = "El email no puede estar vacío")
    @Email(message = "Formato de email inválido")
    private String email;
    
    private String direccion;
}
