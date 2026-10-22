import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RoleListItem, RoleWrite } from '../models/role.model';

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

export function readApiError(error: unknown): string {
  if (!(error instanceof HttpErrorResponse)) {
    return 'No se pudo completar la operación.';
  }

  if (error.status === 0) {
    return 'No se pudo conectar con el API.';
  }

  const body = error.error;
  if (typeof body === 'string' && body.trim() && body !== 'Failed to fetch') {
    return body;
  }

  if (body && typeof body === 'object') {
    const record = body as {
      message?: unknown;
      title?: unknown;
      errors?: Record<string, unknown>;
    };

    if (typeof record.message === 'string' && record.message.trim()) {
      return record.message;
    }

    const firstError = record.errors ? Object.values(record.errors)[0] : undefined;
    if (Array.isArray(firstError) && typeof firstError[0] === 'string') {
      return firstError[0];
    }

    if (typeof record.title === 'string' && record.title.trim()) {
      return record.title;
    }
  }

  return 'No se pudo completar la operación.';
}
