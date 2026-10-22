import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { UserCreate, UserListItem, UserUpdate } from '../models/user.model';

/** ng serve reenvía /api a https://localhost:7156 (el puerto 5184 solo redirige). */
const USERS_URL = '/api/usuarios';

@Injectable({ providedIn: 'root' })
export class UserService {
  private readonly http = inject(HttpClient);

  getAll(): Observable<UserListItem[]> {
    return this.http.get<UserListItem[]>(USERS_URL);
  }

  create(user: UserCreate): Observable<unknown> {
    return this.http.post(USERS_URL, user);
  }

  update(userId: number, user: UserUpdate): Observable<unknown> {
    return this.http.put(`${USERS_URL}/${userId}`, user);
  }

  delete(userId: number): Observable<unknown> {
    return this.http.delete(`${USERS_URL}/${userId}`);
  }
}
