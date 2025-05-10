import axios from 'axios';

const API_URL = 'http://192.168.1.18:9002';

export const clienteService = {
  getAllClientes: () => axios.get(`${API_URL}/api/clientes`),
  getClienteById: (id) => axios.get(`${API_URL}/api/clientes/${id}`),
  getClienteConFacturas: (id) => axios.get(`${API_URL}/api/clientes/${id}/facturas`),
  createCliente: (cliente) => axios.post(`${API_URL}/api/clientes`, cliente),
  updateCliente: (id, cliente) => axios.put(`${API_URL}/api/clientes/${id}`, cliente),
  deleteCliente: (id) => axios.delete(`${API_URL}/api/clientes/${id}`)
};