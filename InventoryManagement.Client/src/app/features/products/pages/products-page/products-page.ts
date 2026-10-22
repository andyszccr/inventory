import { Component, computed, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { readApiError } from '../../../../core/api-error';
import { AppBar } from '../../../../core/layout/app-bar';
import { CategoryListItem } from '../../../categories/models/category.model';
import { CategoryService } from '../../../categories/services/category.service';
import { ProductListItem } from '../../models/product.model';
import { ProductService } from '../../services/product.service';

@Component({
  selector: 'app-products-page',
  imports: [ReactiveFormsModule, AppBar],
  templateUrl: './products-page.html',
  styleUrl: './products-page.css',
})
export class ProductsPage implements OnInit {
  private readonly productsApi = inject(ProductService);
  private readonly categoriesApi = inject(CategoryService);
  private readonly formBuilder = inject(FormBuilder);

  protected readonly products = signal<ProductListItem[]>([]);
  protected readonly categories = signal<CategoryListItem[]>([]);
  protected readonly loading = signal(true);
  protected readonly loadError = signal('');
  protected readonly query = signal('');
  protected readonly editingId = signal<number | null>(null);
  protected readonly saving = signal(false);
  protected readonly deletingId = signal<number | null>(null);
  protected readonly formError = signal('');
  protected readonly notice = signal('');

  protected readonly form = this.formBuilder.nonNullable.group({
    codigo: ['', [Validators.required, Validators.maxLength(50)]],
    nombre: ['', [Validators.required, Validators.maxLength(150)]],
    descripcion: ['', [Validators.maxLength(500)]],
    categoriaId: [0, Validators.min(1)],
    precio: [0, [Validators.required, Validators.min(0)]],
    stock: [0, [Validators.required, Validators.min(0)]],
    stockMinimo: [0, [Validators.required, Validators.min(0)]],
    activo: [true],
  });

  protected readonly visible = computed(() => {
    const term = this.query().trim().toLowerCase();
    const products = this.products();
    if (!term) {
      return products;
    }

    return products.filter((product) => {
      return (
        product.codigo.toLowerCase().includes(term) ||
        product.nombre.toLowerCase().includes(term) ||
        product.categoria.toLowerCase().includes(term)
      );
    });
  });

  ngOnInit(): void {
    void this.load();
  }

  protected onSearch(event: Event): void {
    this.query.set((event.target as HTMLInputElement).value);
  }

  protected amount(value: number): string {
    return new Intl.NumberFormat('es-CR', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(value);
  }

  protected startCreate(): void {
    this.notice.set('');
    this.resetForm();
  }

  protected startEdit(product: ProductListItem): void {
    const category = this.categories().find((item) => item.nombre === product.categoria);
    this.editingId.set(product.productoId);
    this.formError.set('');
    this.notice.set('');
    this.form.reset({
      codigo: product.codigo,
      nombre: product.nombre,
      descripcion: product.descripcion ?? '',
      categoriaId: category?.categoriaId ?? 0,
      precio: product.precioUnitario,
      stock: product.stock,
      stockMinimo: product.stockMinimo,
      activo: product.estado === 'Activo',
    });
  }

  protected async save(): Promise<void> {
    this.formError.set('');
    this.notice.set('');

    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const value = this.form.getRawValue();
    const id = this.editingId();
    const body = {
      codigoProducto: value.codigo.trim(),
      productoName: value.nombre.trim(),
      productoDescription: value.descripcion.trim() || null,
      categoriaId: value.categoriaId,
      unitPrice: Number(value.precio),
      stock: Number(value.stock),
      minimumStock: Number(value.stockMinimo),
      productoStatus: id === null ? true : value.activo,
    };

    this.saving.set(true);
    try {
      if (id === null) {
        await firstValueFrom(this.productsApi.create(body));
      } else {
        await firstValueFrom(this.productsApi.update(id, body));
      }

      this.resetForm();
      this.notice.set(id === null ? 'Producto creado.' : 'Producto actualizado.');
      await this.load(true);
    } catch (error) {
      this.formError.set(readApiError(error));
    } finally {
      this.saving.set(false);
    }
  }

  protected async remove(product: ProductListItem): Promise<void> {
    if (!window.confirm(`¿Eliminar el producto ${product.nombre}?`)) {
      return;
    }

    this.notice.set('');
    this.formError.set('');
    this.deletingId.set(product.productoId);
    try {
      await firstValueFrom(this.productsApi.delete(product.productoId));
      if (this.editingId() === product.productoId) {
        this.resetForm();
      }
      this.notice.set('Producto eliminado.');
      await this.load(true);
    } catch (error) {
      this.formError.set(readApiError(error));
    } finally {
      this.deletingId.set(null);
    }
  }

  private resetForm(): void {
    this.editingId.set(null);
    this.formError.set('');
    this.form.reset({
      codigo: '',
      nombre: '',
      descripcion: '',
      categoriaId: 0,
      precio: 0,
      stock: 0,
      stockMinimo: 0,
      activo: true,
    });
  }

  private async load(silent = false): Promise<void> {
    if (!silent) {
      this.loading.set(true);
    }
    this.loadError.set('');

    try {
      const [products, categories] = await Promise.all([
        firstValueFrom(this.productsApi.getAll()),
        firstValueFrom(this.categoriesApi.getAll()),
      ]);
      this.products.set(products);
      this.categories.set(categories);
    } catch (error) {
      this.products.set([]);
      this.loadError.set(readApiError(error));
    } finally {
      this.loading.set(false);
    }
  }
}
