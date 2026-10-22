export interface MovementListItem {
  movimientoId: number;
  codigoProducto: string;
  nombreProducto: string;
  usuariosId: number;
  nombreUsuario: string;
  tipoMovimiento: string;
  cantidad: number;
  stockPrevio: number;
  nuevoStock: number;
  notas: string | null;
  fecha: string | null;
}

export interface MovementWrite {
  productoId: number;
  usuariosId: number;
  movementType: string;
  cantidad: number;
  notes: string | null;
}
