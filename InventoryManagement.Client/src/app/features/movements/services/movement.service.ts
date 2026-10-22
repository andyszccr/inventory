import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { MovementListItem, MovementWrite } from '../models/movement.model';

/** ng serve reenvía /api a https://localhost:7156 (el puerto 5184 solo redirige). */
const MOVEMENTS_URL = '/api/movimientos';

@Injectable({ providedIn: 'root' })
export class MovementService {
  private readonly http = inject(HttpClient);

  getAll(): Observable<MovementListItem[]> {
    return this.http.get<MovementListItem[]>(MOVEMENTS_URL);
  }

  create(movement: MovementWrite): Observable<unknown> {
    return this.http.post(MOVEMENTS_URL, movement);
  }
}
