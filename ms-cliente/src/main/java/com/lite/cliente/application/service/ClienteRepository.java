package com.lite.cliente.application.service;

import com.lite.cliente.domain.model.Cliente;

import java.util.List;
import java.util.Optional;

public interface ClienteRepository {
    
    Cliente save(Cliente cliente);
    
    Optional<Cliente> findById(Long id);
    
    List<Cliente> findAll();
    
    void deleteById(Long id);
    
    Optional<Cliente> findByEmail(String email);
    
    Optional<Cliente> findByDocumento(String documento);
}
