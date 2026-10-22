export interface CategoryListItem {
  categoriaId: number;
  nombre: string;
  descripcion: string | null;
  estado: string;
  fechaCreacion: string | null;
  fechaModificacion: string | null;
  fechaDesactivacion: string | null;
}

export interface CategoryWrite {
  categoriaName: string;
  categoriaDescription: string | null;
  categoriasStatus: boolean;
}
