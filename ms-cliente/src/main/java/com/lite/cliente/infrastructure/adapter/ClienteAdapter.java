package com.lite.cliente.infrastructure.adapter;

import com.lite.cliente.application.mapper.ClienteMapper;
import com.lite.cliente.application.service.ClienteRepository;
import com.lite.cliente.domain.model.Cliente;

import com.lite.cliente.infrastructure.entity.ClienteEntity;
import com.lite.cliente.infrastructure.repository.ClienteJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class ClienteAdapter implements ClienteRepository {
    
    private final ClienteJpaRepository clienteJpaRepository;
    private final ClienteMapper clienteMapper;
    
    @Override
    public Cliente save(Cliente cliente) {
        ClienteEntity entity = clienteMapper.toEntity(cliente);
        ClienteEntity savedEntity = clienteJpaRepository.save(entity);
        return clienteMapper.toModel(savedEntity);
    }
    
    @Override
    public Optional<Cliente> findById(Long id) {
        return clienteJpaRepository.findById(id)
                .map(clienteMapper::toModel);
    }
    
    @Override
    public List<Cliente> findAll() {
        return clienteJpaRepository.findAll().stream()
                .map(clienteMapper::toModel)
                .collect(Collectors.toList());
    }
    
    @Override
    public void deleteById(Long id) {
        clienteJpaRepository.deleteById(id);
    }
    
    @Override
    public Optional<Cliente> findByEmail(String email) {
        return clienteJpaRepository.findByEmail(email)
                .map(clienteMapper::toModel);
    }
    
    @Override
    public Optional<Cliente> findByDocumento(String documento) {
        return clienteJpaRepository.findByDocumento(documento)
                .map(clienteMapper::toModel);
    }
}
