import axios from 'axios';

// Cuando usamos proxy, no necesitamos la URL base completa
// El proxy redirigirá automáticamente las solicitudes a tu backend

export const clienteService = {
  getAllClientes: () => axios.get('/api/clientes'),
  getClienteById: (id) => axios.get(`/api/clientes/${id}`),
  getClienteConFacturas: (id) => axios.get(`/api/clientes/${id}/facturas`),
  createCliente: (cliente) => axios.post('/api/clientes', cliente),
  updateCliente: (id, cliente) => axios.put(`/api/clientes/${id}`, cliente),
  deleteCliente: (id) => axios.delete(`/api/clientes/${id}`)
};