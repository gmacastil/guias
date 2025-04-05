package com.lite.factura.infrastructure.adapter;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import com.lite.factura.application.mapper.FacturaMapper;
import com.lite.factura.application.service.FacturaRepository;
import com.lite.factura.domain.model.Factura;
import com.lite.factura.infrastructure.entity.FacturaEntity;
import com.lite.factura.infrastructure.repository.FacturaJpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class FacturaAdapter implements FacturaRepository {
    
    private final FacturaJpaRepository facturaJpaRepository;
    private final FacturaMapper facturaMapper;
    
    @Override
    public Factura save(Factura factura) {
        FacturaEntity entity = facturaMapper.toEntity(factura);
        FacturaEntity savedEntity = facturaJpaRepository.save(entity);
        return facturaMapper.toModel(savedEntity);
    }
    
    @Override
    public Optional<Factura> findById(Long id) {
        return facturaJpaRepository.findById(id)
                .map(facturaMapper::toModel);
    }
    
    @Override
    public List<Factura> findAll() {
        return facturaJpaRepository.findAll().stream()
                .map(facturaMapper::toModel)
                .collect(Collectors.toList());
    }
    
    @Override
    public void deleteById(Long id) {
        facturaJpaRepository.deleteById(id);
    }
    
    @Override
    public List<Factura> findByClienteId(Long clienteId) {
        return facturaJpaRepository.findByClienteId(clienteId).stream()
                .map(facturaMapper::toModel)
                .collect(Collectors.toList());
    }
}
