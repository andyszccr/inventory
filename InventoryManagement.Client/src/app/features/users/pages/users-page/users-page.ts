import { HttpErrorResponse } from '@angular/common/http';
import { Component, computed, inject, OnInit, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { readApiError } from '../../../../core/api-error';
import { AuthService } from '../../../../core/auth/auth.service';
import { AppBar } from '../../../../core/layout/app-bar';
import { RoleListItem } from '../../../roles/models/role.model';
import { RoleService } from '../../../roles/services/role.service';
import { UserListItem } from '../../models/user.model';
import { UserService } from '../../services/user.service';

@Component({
  selector: 'app-users-page',
  imports: [ReactiveFormsModule, AppBar],
  templateUrl: './users-page.html',
  styleUrl: './users-page.css',
})
export class UsersPage implements OnInit {
  protected readonly auth = inject(AuthService);
  private readonly usersApi = inject(UserService);
  private readonly rolesApi = inject(RoleService);
  private readonly formBuilder = inject(FormBuilder);

  protected readonly users = signal<UserListItem[]>([]);
  protected readonly roles = signal<RoleListItem[]>([]);
  protected readonly loading = signal(false);
  protected readonly loadError = signal('');
  protected readonly query = signal('');
  protected readonly editingId = signal<number | null>(null);
  protected readonly saving = signal(false);
  protected readonly deletingId = signal<number | null>(null);
  protected readonly formError = signal('');
  protected readonly notice = signal('');
  protected readonly loggingIn = signal(false);
  protected readonly loginError = signal('');

  protected readonly loginForm = this.formBuilder.nonNullable.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', Validators.required],
  });

  protected readonly form = this.formBuilder.nonNullable.group({
    nombre: ['', [Validators.required, Validators.maxLength(150)]],
    email: ['', [Validators.required, Validators.email, Validators.maxLength(150)]],
    password: ['', [Validators.required, Validators.minLength(8), Validators.maxLength(100)]],
    roleId: [0, Validators.min(1)],
    activo: [true],
  });

  protected readonly visible = computed(() => {
    const term = this.query().trim().toLowerCase();
    const users = this.users();
    if (!term) {
      return users;
    }

    return users.filter((user) => {
      return (
        user.nombreCompleto.toLowerCase().includes(term) ||
        user.email.toLowerCase().includes(term) ||
        user.rol.toLowerCase().includes(term)
      );
    });
  });

  ngOnInit(): void {
    if (this.auth.token()) {
      void this.load();
    }
  }

  protected onSearch(event: Event): void {
    this.query.set((event.target as HTMLInputElement).value);
  }

  protected async enter(): Promise<void> {
    this.loginError.set('');
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    const value = this.loginForm.getRawValue();
    this.loggingIn.set(true);
    try {
      const response = await firstValueFrom(
        this.auth.login(value.email.trim(), value.password),
      );
      this.auth.persist(response);
      this.loginForm.reset({ email: '', password: '' });
      await this.load();
    } catch (error) {
      this.loginError.set(readApiError(error));
    } finally {
      this.loggingIn.set(false);
    }
  }

  protected startCreate(): void {
    this.notice.set('');
    this.resetForm();
  }

  protected startEdit(user: UserListItem): void {
    const role = this.roles().find((item) => item.nombre === user.rol);
    this.editingId.set(user.usuariosId);
    this.formError.set('');
    this.notice.set('');
    this.form.controls.password.clearValidators();
    this.form.controls.password.updateValueAndValidity();
    this.form.reset({
      nombre: user.nombreCompleto,
      email: user.email,
      password: '',
      roleId: role?.roleId ?? 0,
      activo: user.estado === 'Activo',
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
    this.saving.set(true);
    try {
      if (id === null) {
        await firstValueFrom(
          this.usersApi.create({
            nombreCompleto: value.nombre.trim(),
            email: value.email.trim(),
            password: value.password,
            roleId: value.roleId,
          }),
        );
      } else {
        await firstValueFrom(
          this.usersApi.update(id, {
            nombreCompleto: value.nombre.trim(),
            email: value.email.trim(),
            roleId: value.roleId,
            usuarioStatus: value.activo,
          }),
        );
      }

      this.resetForm();
      this.notice.set(id === null ? 'Usuario creado.' : 'Usuario actualizado.');
      await this.load(true);
    } catch (error) {
      this.formError.set(this.messageFor(error));
    } finally {
      this.saving.set(false);
    }
  }

  protected async remove(user: UserListItem): Promise<void> {
    if (!window.confirm(`¿Eliminar a ${user.nombreCompleto}?`)) {
      return;
    }

    this.notice.set('');
    this.formError.set('');
    this.deletingId.set(user.usuariosId);
    try {
      await firstValueFrom(this.usersApi.delete(user.usuariosId));
      if (this.editingId() === user.usuariosId) {
        this.resetForm();
      }
      this.notice.set('Usuario eliminado.');
      await this.load(true);
    } catch (error) {
      this.formError.set(this.messageFor(error));
    } finally {
      this.deletingId.set(null);
    }
  }

  private resetForm(): void {
    this.editingId.set(null);
    this.formError.set('');
    this.form.controls.password.setValidators([
      Validators.required,
      Validators.minLength(8),
      Validators.maxLength(100),
    ]);
    this.form.reset({ nombre: '', email: '', password: '', roleId: 0, activo: true });
    this.form.controls.password.updateValueAndValidity();
  }

  private async load(silent = false): Promise<void> {
    if (!silent) {
      this.loading.set(true);
    }
    this.loadError.set('');

    try {
      const [users, roles] = await Promise.all([
        firstValueFrom(this.usersApi.getAll()),
        firstValueFrom(this.rolesApi.getAll()),
      ]);
      this.users.set(users);
      this.roles.set(roles);
    } catch (error) {
      if (error instanceof HttpErrorResponse && error.status === 401) {
        this.auth.logout();
        this.loginError.set('La sesión no es válida. Entra de nuevo.');
        return;
      }

      this.users.set([]);
      this.loadError.set(readApiError(error));
    } finally {
      this.loading.set(false);
    }
  }

  private messageFor(error: unknown): string {
    if (error instanceof HttpErrorResponse && error.status === 401) {
      this.auth.logout();
      this.loginError.set('La sesión no es válida. Entra de nuevo.');
      return '';
    }

    return readApiError(error);
  }
}
