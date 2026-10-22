import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { readApiError } from '../../../core/api-error';
import { RoleListItem, RoleWrite } from '../models/role.model';

export { readApiError };

/**
 * En desarrollo, ng serve reenvía /api al API.
 * El perfil HTTPS escucha en https://localhost:7156 y el HTTP de :5184 solo redirige ahí.
 */
const ROLES_URL = '/api/roles';

@Injectable({ providedIn: 'root' })
export class RoleService {
  private readonly http = inject(HttpClient);

  getAll(): Observable<RoleListItem[]> {
    return this.http.get<RoleListItem[]>(ROLES_URL);
  }

  create(role: RoleWrite): Observable<unknown> {
    return this.http.post(ROLES_URL, {
      rolesName: role.rolesName,
      rolesDescription: role.rolesDescription,
    });
  }

  update(roleId: number, role: RoleWrite): Observable<unknown> {
    return this.http.put(`${ROLES_URL}/${roleId}`, {
      rolesName: role.rolesName,
      rolesDescription: role.rolesDescription,
      isActive: role.isActive ?? true,
    });
  }
}
