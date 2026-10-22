export interface RoleListItem {
  roleId: number;
  nombre: string;
  descripcion: string | null;
  estado: string;
  fechaCreacion: string | null;
  fechaModificacion: string | null;
  fechaDesactivacion: string | null;
}

export interface RoleWrite {
  rolesName: string;
  rolesDescription: string | null;
  isActive?: boolean;
}
