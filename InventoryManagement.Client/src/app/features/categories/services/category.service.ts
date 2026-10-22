import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { CategoryListItem, CategoryWrite } from '../models/category.model';

/** ng serve reenvía /api a https://localhost:7156 (el puerto 5184 solo redirige). */
const CATEGORIES_URL = '/api/categorias';

@Injectable({ providedIn: 'root' })
export class CategoryService {
  private readonly http = inject(HttpClient);

  getAll(): Observable<CategoryListItem[]> {
    return this.http.get<CategoryListItem[]>(CATEGORIES_URL);
  }

  create(category: CategoryWrite): Observable<unknown> {
    return this.http.post(CATEGORIES_URL, category);
  }

  update(categoryId: number, category: CategoryWrite): Observable<unknown> {
    return this.http.put(`${CATEGORIES_URL}/${categoryId}`, category);
  }

  delete(categoryId: number): Observable<unknown> {
    return this.http.delete(`${CATEGORIES_URL}/${categoryId}`);
  }
}
