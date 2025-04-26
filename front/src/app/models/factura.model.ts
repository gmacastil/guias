export interface Factura {
  id?: number;
  numero: string;
  fechaEmision: string;
  total: number;
  clienteId: number;
  descripcion?: string;
}
