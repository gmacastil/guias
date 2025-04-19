package com.lite.cliente.infrastructure.repository;

import com.lite.cliente.infrastructure.entity.ClienteEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ClienteJpaRepository extends JpaRepository<ClienteEntity, Long> {
    
    Optional<ClienteEntity> findByEmail(String email);
    
    Optional<ClienteEntity> findByDocumento(String documento);
}
