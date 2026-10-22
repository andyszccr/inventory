import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ProductListItem, ProductWrite } from '../models/product.model';

/** ng serve reenvía /api a https://localhost:7156 (el puerto 5184 solo redirige). */
const PRODUCTS_URL = '/api/productos';

@Injectable({ providedIn: 'root' })
export class ProductService {
  private readonly http = inject(HttpClient);

  getAll(): Observable<ProductListItem[]> {
    return this.http.get<ProductListItem[]>(PRODUCTS_URL);
  }

  create(product: ProductWrite): Observable<unknown> {
    return this.http.post(PRODUCTS_URL, product);
  }

  update(productId: number, product: ProductWrite): Observable<unknown> {
    return this.http.put(`${PRODUCTS_URL}/${productId}`, product);
  }

  delete(productId: number): Observable<unknown> {
    return this.http.delete(`${PRODUCTS_URL}/${productId}`);
  }
}
