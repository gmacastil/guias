package com.lite.cliente.application.mapper;

import com.lite.cliente.domain.dto.ClienteDTO;
import com.lite.cliente.domain.model.Cliente;
import com.lite.cliente.infrastructure.entity.ClienteEntity;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ClienteMapper {
    
    ClienteMapper INSTANCE = Mappers.getMapper(ClienteMapper.class);
    
    Cliente toModel(ClienteDTO dto);
    
    ClienteDTO toDto(Cliente model);
    
    List<ClienteDTO> toDtoList(List<Cliente> modelList);
    
    Cliente toModel(ClienteEntity entity);
    
    ClienteEntity toEntity(Cliente model);
    
    List<Cliente> toModelList(List<ClienteEntity> entityList);
}
