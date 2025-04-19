package com.lite.cliente.infrastructure.controller;

import com.lite.cliente.application.exception.ResourceNotFoundException;
import com.lite.cliente.application.mapper.ClienteMapper;
import com.lite.cliente.application.service.ClienteUseCase;
import com.lite.cliente.domain.dto.ClienteConFacturasDTO;
import com.lite.cliente.domain.dto.ClienteDTO;
import com.lite.cliente.domain.dto.FacturaDTO;
import com.lite.cliente.domain.model.Cliente;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/clientes")
@RequiredArgsConstructor
public class ClienteController {
    
    private final ClienteUseCase clienteUseCase;
    private final ClienteMapper clienteMapper;
    
    @PostMapping
    public ResponseEntity<ClienteDTO> createCliente(@Valid @RequestBody ClienteDTO clienteDTO) {
        Cliente cliente = clienteMapper.toModel(clienteDTO);
        Cliente createdCliente = clienteUseCase.createCliente(cliente);
        return new ResponseEntity<>(clienteMapper.toDto(createdCliente), HttpStatus.CREATED);
    }
    
    @GetMapping
    public ResponseEntity<List<ClienteDTO>> getAllClientes() {
        List<Cliente> clientes = clienteUseCase.getAllClientes();
        return ResponseEntity.ok(clienteMapper.toDtoList(clientes));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ClienteDTO> getClienteById(@PathVariable Long id) {
        Cliente cliente = clienteUseCase.getClienteById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente", "id", id));
        return ResponseEntity.ok(clienteMapper.toDto(cliente));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<ClienteDTO> updateCliente(@PathVariable Long id, @Valid @RequestBody ClienteDTO clienteDTO) {
        // Verificar si el cliente existe
        clienteUseCase.getClienteById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente", "id", id));
        
        Cliente clienteDetails = clienteMapper.toModel(clienteDTO);
        Cliente updatedCliente = clienteUseCase.updateCliente(id, clienteDetails);
        return ResponseEntity.ok(clienteMapper.toDto(updatedCliente));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCliente(@PathVariable Long id) {
        // Verificar si el cliente existe
        clienteUseCase.getClienteById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente", "id", id));
        
        clienteUseCase.deleteCliente(id);
        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/{id}/facturas")
    public ResponseEntity<ClienteConFacturasDTO> getClienteConFacturas(@PathVariable Long id) {
        // Verificar si el cliente existe
        Cliente cliente = clienteUseCase.getClienteById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente", "id", id));
        
        // Obtener las facturas del cliente
        List<FacturaDTO> facturas = clienteUseCase.getFacturasByClienteId(id);
        
        // Crear y devolver el DTO con el cliente y sus facturas
        ClienteConFacturasDTO clienteConFacturas = new ClienteConFacturasDTO(
                clienteMapper.toDto(cliente),
                facturas
        );
        
        return ResponseEntity.ok(clienteConFacturas);
    }
}
