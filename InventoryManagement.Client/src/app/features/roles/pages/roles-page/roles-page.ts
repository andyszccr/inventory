import { Component, computed, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { AppBar } from '../../../../core/layout/app-bar';
import { RoleListItem } from '../../models/role.model';
import { readApiError, RoleService } from '../../services/role.service';

@Component({
  selector: 'app-roles-page',
  imports: [ReactiveFormsModule, AppBar],
  templateUrl: './roles-page.html',
  styleUrl: './roles-page.css',
})
export class RolesPage implements OnInit {
  private readonly rolesApi = inject(RoleService);
  private readonly formBuilder = inject(FormBuilder);

  protected readonly roles = signal<RoleListItem[]>([]);
  protected readonly loading = signal(true);
  protected readonly loadError = signal('');
  protected readonly query = signal('');
  protected readonly editingId = signal<number | null>(null);
  protected readonly saving = signal(false);
  protected readonly formError = signal('');
  protected readonly notice = signal('');

  protected readonly form = this.formBuilder.nonNullable.group({
    nombre: ['', [Validators.required, Validators.maxLength(50)]],
    descripcion: ['', [Validators.maxLength(200)]],
    activo: [true],
  });

  protected readonly visible = computed(() => {
    const term = this.query().trim().toLowerCase();
    const roles = this.roles();
    if (!term) {
      return roles;
    }

    return roles.filter((role) => {
      const description = role.descripcion ?? '';
      return role.nombre.toLowerCase().includes(term) || description.toLowerCase().includes(term);
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

  protected startEdit(role: RoleListItem): void {
    this.editingId.set(role.roleId);
    this.formError.set('');
    this.notice.set('');
    this.form.reset({
      nombre: role.nombre,
      descripcion: role.descripcion ?? '',
      activo: role.estado === 'Activo',
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
      rolesName: value.nombre.trim(),
      rolesDescription: value.descripcion.trim() || null,
      isActive: value.activo,
    };

    this.saving.set(true);
    try {
      const id = this.editingId();
      if (id === null) {
        await firstValueFrom(this.rolesApi.create(body));
      } else {
        await firstValueFrom(this.rolesApi.update(id, body));
      }

      this.resetForm();
      this.notice.set(id === null ? 'Rol creado.' : 'Rol actualizado.');
      await this.load(true);
    } catch (error) {
      this.formError.set(readApiError(error));
    } finally {
      this.saving.set(false);
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
      const roles = await firstValueFrom(this.rolesApi.getAll());
      this.roles.set(roles);
    } catch (error) {
      this.roles.set([]);
      this.loadError.set(readApiError(error));
    } finally {
      this.loading.set(false);
    }
  }
}
