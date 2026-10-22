export interface UserListItem {
  usuariosId: number;
  nombreCompleto: string;
  email: string;
  rol: string;
  estado: string;
  fechaCreacion: string | null;
  fechaModificacion: string | null;
  fechaDesactivacion: string | null;
}

export interface UserCreate {
  nombreCompleto: string;
  email: string;
  password: string;
  roleId: number;
}

export interface UserUpdate {
  nombreCompleto: string;
  email: string;
  roleId: number;
  usuarioStatus: boolean;
}
