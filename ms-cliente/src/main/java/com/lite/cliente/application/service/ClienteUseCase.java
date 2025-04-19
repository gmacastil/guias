package com.lite.cliente.application.service;

import com.lite.cliente.domain.dto.FacturaDTO;
import com.lite.cliente.domain.model.Cliente;

import java.util.List;
import java.util.Optional;

public interface ClienteUseCase {
    
    Cliente createCliente(Cliente cliente);
    
    Optional<Cliente> getClienteById(Long id);
    
    List<Cliente> getAllClientes();
    
    Cliente updateCliente(Long id, Cliente clienteDetails);
    
    void deleteCliente(Long id);
    
    List<FacturaDTO> getFacturasByClienteId(Long clienteId);
}
