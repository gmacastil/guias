package com.lite.cliente.application.service;

import com.lite.cliente.application.exception.ResourceNotFoundException;
import com.lite.cliente.domain.dto.FacturaDTO;
import com.lite.cliente.domain.model.Cliente;
import com.lite.cliente.infrastructure.feign.FacturaFeignClient;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClienteService implements ClienteUseCase {
    
    private final ClienteRepository clienteRepository;
    private final FacturaFeignClient facturaFeignClient;
    
    @Override
    public Cliente createCliente(Cliente cliente) {
        return clienteRepository.save(cliente);
    }
    
    @Override
    public Optional<Cliente> getClienteById(Long id) {
        return clienteRepository.findById(id);
    }
    
    @Override
    public List<Cliente> getAllClientes() {
        return clienteRepository.findAll();
    }
    
    @Override
    public Cliente updateCliente(Long id, Cliente clienteDetails) {
        Optional<Cliente> clienteOpt = clienteRepository.findById(id);
        
        if (clienteOpt.isPresent()) {
            clienteDetails.setId(id);
            return clienteRepository.save(clienteDetails);
        } else {
            throw new ResourceNotFoundException("Cliente", "id", id);
        }
    }
    
    @Override
    public void deleteCliente(Long id) {
        clienteRepository.deleteById(id);
    }
    
    @Override
    public List<FacturaDTO> getFacturasByClienteId(Long clienteId) {
        // Verificar si el cliente existe
        clienteRepository.findById(clienteId)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente", "id", clienteId));
        
        // Obtener las facturas del cliente desde el servicio de facturas
        return facturaFeignClient.getFacturasByClienteId(clienteId);
    }
}
