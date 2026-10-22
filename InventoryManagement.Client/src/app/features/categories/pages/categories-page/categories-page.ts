import { Component, computed, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { readApiError } from '../../../../core/api-error';
import { AppBar } from '../../../../core/layout/app-bar';
import { CategoryListItem } from '../../models/category.model';
import { CategoryService } from '../../services/category.service';

@Component({
  selector: 'app-categories-page',
  imports: [ReactiveFormsModule, AppBar],
  templateUrl: './categories-page.html',
  styleUrl: './categories-page.css',
})
export class CategoriesPage implements OnInit {
  private readonly categoriesApi = inject(CategoryService);
  private readonly formBuilder = inject(FormBuilder);

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
    nombre: ['', [Validators.required, Validators.maxLength(100)]],
    descripcion: ['', [Validators.maxLength(250)]],
    activo: [true],
  });

  protected readonly visible = computed(() => {
    const term = this.query().trim().toLowerCase();
    const categories = this.categories();
    if (!term) {
      return categories;
    }

    return categories.filter((category) => {
      const description = category.descripcion ?? '';
      return category.nombre.toLowerCase().includes(term) || description.toLowerCase().includes(term);
    });
  });

  ngOnInit(): void {
    void this.load();
  }

  protected onSearch(event: Event): void {
    this.query.set((event.target as HTMLInputElement).value);
  }

  protected startCreate(): void {
    this.notice.set('');
    this.resetForm();
  }

  protected startEdit(category: CategoryListItem): void {
    this.editingId.set(category.categoriaId);
    this.formError.set('');
    this.notice.set('');
    this.form.reset({
      nombre: category.nombre,
      descripcion: category.descripcion ?? '',
      activo: category.estado === 'Activo',
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
    const body = {
      categoriaName: value.nombre.trim(),
      categoriaDescription: value.descripcion.trim() || null,
      categoriasStatus: this.editingId() === null ? true : value.activo,
    };
    const id = this.editingId();

    this.saving.set(true);
    try {
      if (id === null) {
        await firstValueFrom(this.categoriesApi.create(body));
      } else {
        await firstValueFrom(this.categoriesApi.update(id, body));
      }

      this.resetForm();
      this.notice.set(id === null ? 'Categoría creada.' : 'Categoría actualizada.');
      await this.load(true);
    } catch (error) {
      this.formError.set(readApiError(error));
    } finally {
      this.saving.set(false);
    }
  }

  protected async remove(category: CategoryListItem): Promise<void> {
    if (!window.confirm(`¿Eliminar la categoría ${category.nombre}?`)) {
      return;
    }

    this.notice.set('');
    this.formError.set('');
    this.deletingId.set(category.categoriaId);
    try {
      await firstValueFrom(this.categoriesApi.delete(category.categoriaId));
      if (this.editingId() === category.categoriaId) {
        this.resetForm();
      }
      this.notice.set('Categoría eliminada.');
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
    this.form.reset({ nombre: '', descripcion: '', activo: true });
  }

  private async load(silent = false): Promise<void> {
    if (!silent) {
      this.loading.set(true);
    }
    this.loadError.set('');

    try {
      const categories = await firstValueFrom(this.categoriesApi.getAll());
      this.categories.set(categories);
    } catch (error) {
      this.categories.set([]);
      this.loadError.set(readApiError(error));
    } finally {
      this.loading.set(false);
    }
  }
}
