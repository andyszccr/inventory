export interface ProductListItem {
  productoId: number;
  codigo: string;
  nombre: string;
  descripcion: string | null;
  categoria: string;
  precioUnitario: number;
  stock: number;
  stockMinimo: number;
  estado: string;
  fechaCreacion: string | null;
  fechaModificacion: string | null;
  fechaDesactivacion: string | null;
}

export interface ProductWrite {
  codigoProducto: string;
  productoName: string;
  productoDescription: string | null;
  categoriaId: number;
  unitPrice: number;
  stock: number;
  minimumStock: number;
  productoStatus: boolean;
}
