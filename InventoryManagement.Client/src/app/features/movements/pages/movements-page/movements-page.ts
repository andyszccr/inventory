import { HttpErrorResponse } from '@angular/common/http';
import { Component, computed, inject, OnInit, signal } from '@angular/core';
import { AbstractControl, FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { readApiError } from '../../../../core/api-error';
import { AuthService } from '../../../../core/auth/auth.service';
import { AppBar } from '../../../../core/layout/app-bar';
import { ProductListItem } from '../../../products/models/product.model';
import { ProductService } from '../../../products/services/product.service';
import { UserListItem } from '../../../users/models/user.model';
import { UserService } from '../../../users/services/user.service';
import { MovementListItem } from '../../models/movement.model';
import { MovementService } from '../../services/movement.service';

@Component({
  selector: 'app-movements-page',
  imports: [ReactiveFormsModule, AppBar],
  templateUrl: './movements-page.html',
  styleUrl: './movements-page.css',
})
export class MovementsPage implements OnInit {
  protected readonly auth = inject(AuthService);
  private readonly movementsApi = inject(MovementService);
  private readonly productsApi = inject(ProductService);
  private readonly usersApi = inject(UserService);
  private readonly formBuilder = inject(FormBuilder);

  protected readonly types = [
    { id: 'ENTRADA', label: 'Entrada' },
    { id: 'SALIDA', label: 'Salida' },
    { id: 'AJUSTE', label: 'Ajuste' },
  ];

  protected readonly movements = signal<MovementListItem[]>([]);
  protected readonly products = signal<ProductListItem[]>([]);
  protected readonly users = signal<UserListItem[]>([]);
  protected readonly loading = signal(true);
  protected readonly loadError = signal('');
  protected readonly query = signal('');
  protected readonly saving = signal(false);
  protected readonly formError = signal('');
  protected readonly notice = signal('');
  protected readonly loggingIn = signal(false);
  protected readonly loginError = signal('');
  protected readonly productId = signal(0);
  protected readonly movementType = signal('ENTRADA');

  protected readonly loginForm = this.formBuilder.nonNullable.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', Validators.required],
  });

  protected readonly form = this.formBuilder.group({
    productoId: [0, Validators.min(1)],
    usuariosId: [0, Validators.min(1)],
    tipo: ['ENTRADA', Validators.required],
    cantidad: [null as number | null, [Validators.required, positiveAmount]],
    notas: ['', Validators.maxLength(500)],
  });

  protected readonly visible = computed(() => {
    const term = this.query().trim().toLowerCase();
    const movements = this.movements();
    if (!term) {
      return movements;
    }

    return movements.filter((movement) => {
      const tipo = movement.tipoMovimiento.toLowerCase();
      return (
        movement.codigoProducto.toLowerCase().includes(term) ||
        movement.nombreProducto.toLowerCase().includes(term) ||
        movement.nombreUsuario.toLowerCase().includes(term) ||
        tipo.includes(term) ||
        typeLabel(movement.tipoMovimiento).toLowerCase().includes(term) ||
        (movement.notas ?? '').toLowerCase().includes(term)
      );
    });
  });

  protected readonly currentProduct = computed(() => {
    const id = this.productId();
    return this.products().find((product) => product.productoId === id) ?? null;
  });

  ngOnInit(): void {
    void this.load();
  }

  protected onSearch(event: Event): void {
    this.query.set((event.target as HTMLInputElement).value);
  }

  protected syncProduct(): void {
    this.productId.set(Number(this.form.controls.productoId.value) || 0);
  }

  protected syncType(): void {
    this.movementType.set(this.form.controls.tipo.value || 'ENTRADA');
  }

  protected amount(value: number): string {
    return new Intl.NumberFormat('es-CR', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(value);
  }

  protected typeLabel(tipo: string): string {
    return typeLabel(tipo);
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
      const response = await firstValueFrom(this.auth.login(value.email.trim(), value.password));
      this.auth.persist(response);
      this.loginForm.reset({ email: '', password: '' });
      await this.loadUsers();
    } catch (error) {
      this.loginError.set(readApiError(error));
    } finally {
      this.loggingIn.set(false);
    }
  }

  protected async save(): Promise<void> {
    this.formError.set('');
    this.notice.set('');

    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const value = this.form.getRawValue();
    this.saving.set(true);
    try {
      await firstValueFrom(
        this.movementsApi.create({
          productoId: Number(value.productoId),
          usuariosId: Number(value.usuariosId),
          movementType: value.tipo ?? 'ENTRADA',
          cantidad: Number(value.cantidad),
          notes: value.notas?.trim() || null,
        }),
      );
      this.resetForm();
      this.notice.set('Movimiento registrado.');
      await this.load(true);
    } catch (error) {
      this.formError.set(readApiError(error));
    } finally {
      this.saving.set(false);
    }
  }

  private resetForm(): void {
    const userId = this.form.controls.usuariosId.value ?? 0;
    this.form.reset({
      productoId: 0,
      usuariosId: userId,
      tipo: 'ENTRADA',
      cantidad: null,
      notas: '',
    });
    this.formError.set('');
    this.productId.set(0);
    this.movementType.set('ENTRADA');
  }

  private async load(silent = false): Promise<void> {
    if (!silent) {
      this.loading.set(true);
    }
    this.loadError.set('');

    try {
      const [movements, products] = await Promise.all([
        firstValueFrom(this.movementsApi.getAll()),
        firstValueFrom(this.productsApi.getAll()),
      ]);
      this.movements.set(movements);
      this.products.set(products.filter((product) => product.estado === 'Activo'));
      if (this.auth.token()) {
        await this.loadUsers();
      }
    } catch (error) {
      this.movements.set([]);
      this.loadError.set(readApiError(error));
    } finally {
      this.loading.set(false);
    }
  }

  private async loadUsers(): Promise<void> {
    try {
      const users = await firstValueFrom(this.usersApi.getAll());
      this.users.set(users);
      this.applyDefaultUser();
    } catch (error) {
      this.users.set([]);
      if (error instanceof HttpErrorResponse && error.status === 401) {
        this.auth.logout();
        return;
      }
      this.formError.set(readApiError(error));
    }
  }

  private applyDefaultUser(): void {
    const current = Number(this.form.controls.usuariosId.value) || 0;
    if (current > 0 && this.users().some((user) => user.usuariosId === current)) {
      return;
    }

    const sessionId = this.auth.user()?.usuariosId ?? 0;
    if (this.users().some((user) => user.usuariosId === sessionId)) {
      this.form.controls.usuariosId.setValue(sessionId);
    }
  }
}

function typeLabel(tipo: string): string {
  switch (tipo) {
    case 'ENTRADA':
      return 'Entrada';
    case 'SALIDA':
      return 'Salida';
    case 'AJUSTE':
      return 'Ajuste';
    default:
      return tipo;
  }
}

function positiveAmount(control: AbstractControl): { positive: true } | null {
  const value = Number(control.value);
  return Number.isFinite(value) && value > 0 ? null : { positive: true };
}
