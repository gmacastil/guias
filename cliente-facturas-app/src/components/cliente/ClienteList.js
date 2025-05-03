import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { clienteService } from '../../services/api';
import './ClienteList.css';

const ClienteList = () => {
  const [clientes, setClientes] = useState([]);
  const [filtro, setFiltro] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchClientes = async () => {
      try {
        const response = await clienteService.getAllClientes();
        setClientes(response.data);
        setLoading(false);
      } catch (err) {
        setError('Error al cargar los clientes');
        setLoading(false);
        console.error('Error al cargar los clientes:', err);
      }
    };

    fetchClientes();
  }, []);

  const clientesFiltrados = clientes.filter(cliente => 
    cliente.nombre.toLowerCase().includes(filtro.toLowerCase()) || 
    cliente.apellido.toLowerCase().includes(filtro.toLowerCase()) ||
    cliente.documento.toLowerCase().includes(filtro.toLowerCase())
  );

  if (loading) return <div className="text-center mt-5"><div className="spinner-border" role="status"></div></div>;
  if (error) return <div className="alert alert-danger mt-3">{error}</div>;

  return (
    <div className="cliente-list">
      <h2>Lista de Clientes</h2>
      
      <div className="mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Buscar por nombre, apellido o documento..."
          value={filtro}
          onChange={(e) => setFiltro(e.target.value)}
        />
      </div>

      <div className="table-responsive">
        <table className="table table-striped table-hover">
          <thead>
            <tr>
              <th>ID</th>
              <th>Nombre</th>
              <th>Apellido</th>
              <th>Documento</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {clientesFiltrados.length > 0 ? (
              clientesFiltrados.map((cliente) => (
                <tr key={cliente.id}>
                  <td>{cliente.id}</td>
                  <td>{cliente.nombre}</td>
                  <td>{cliente.apellido}</td>
                  <td>{cliente.documento}</td>
                  <td>
                    <Link to={`/clientes/${cliente.id}`} className="btn btn-primary btn-sm me-2">
                      Ver Facturas
                    </Link>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="5" className="text-center">
                  No se encontraron clientes
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ClienteList;
