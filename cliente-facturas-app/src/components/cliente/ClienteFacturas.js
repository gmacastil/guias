import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { clienteService } from '../../services/api';
import './ClienteFacturas.css';

const ClienteFacturas = () => {
  const { id } = useParams();
  const [clienteConFacturas, setClienteConFacturas] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchClienteConFacturas = async () => {
      try {
        const response = await clienteService.getClienteConFacturas(id);
        setClienteConFacturas(response.data);
        setLoading(false);
      } catch (err) {
        setError('Error al cargar las facturas del cliente');
        setLoading(false);
        console.error('Error al cargar las facturas del cliente:', err);
      }
    };

    fetchClienteConFacturas();
  }, [id]);

  if (loading) return <div className="text-center mt-5"><div className="spinner-border" role="status"></div></div>;
  if (error) return <div className="alert alert-danger mt-3">{error}</div>;
  if (!clienteConFacturas) return <div className="alert alert-warning mt-3">No se encontró información del cliente</div>;

  const { cliente, facturas } = clienteConFacturas;

  return (
    <div className="cliente-facturas">
      <div className="mb-3">
        <Link to="/" className="btn btn-secondary">
          ← Volver a la lista de clientes
        </Link>
      </div>

      <div className="card mb-4">
        <div className="card-header">
          <h3>Información del Cliente</h3>
        </div>
        <div className="card-body">
          <h4>{cliente.nombre} {cliente.apellido}</h4>
          <p><strong>Documento:</strong> {cliente.documento}</p>
          <p><strong>Email:</strong> {cliente.email}</p>
          <p><strong>Teléfono:</strong> {cliente.telefono}</p>
          {cliente.direccion && <p><strong>Dirección:</strong> {cliente.direccion}</p>}
        </div>
      </div>

      <h3>Facturas del Cliente</h3>
      {facturas && facturas.length > 0 ? (
        <div className="table-responsive">
          <table className="table table-striped">
            <thead>
              <tr>
                <th>Número</th>
                <th>Fecha de Emisión</th>
                <th>Descripción</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody>
              {facturas.map((factura) => (
                <tr key={factura.id}>
                  <td>{factura.numero}</td>
                  <td>{new Date(factura.fechaEmision).toLocaleDateString()}</td>
                  <td>{factura.descripcion}</td>
                  <td>${factura.total.toFixed(2)}</td>
                </tr>
              ))}
            </tbody>
            <tfoot>
              <tr>
                <td colSpan="3" className="text-end"><strong>Total:</strong></td>
                <td><strong>${facturas.reduce((sum, factura) => sum + factura.total, 0).toFixed(2)}</strong></td>
              </tr>
            </tfoot>
          </table>
        </div>
      ) : (
        <div className="alert alert-info">
          Este cliente no tiene facturas registradas.
        </div>
      )}
    </div>
  );
};

export default ClienteFacturas;
