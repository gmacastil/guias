import { Cliente } from './cliente.model';
import { Factura } from './factura.model';

export interface ClienteConFacturas {
  cliente: Cliente;
  facturas: Factura[];
}
