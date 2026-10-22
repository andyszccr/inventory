import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { firstValueFrom } from 'rxjs';
import { readApiError } from '../api-error';
import { AuthService } from './auth.service';

@Component({
  selector: 'app-login-page',
  imports: [ReactiveFormsModule],
  templateUrl: './login-page.html',
  styleUrl: './login-page.css',
})
export class LoginPage {
  private readonly auth = inject(AuthService);
  private readonly router = inject(Router);
  private readonly formBuilder = inject(FormBuilder);

  protected readonly loggingIn = signal(false);
  protected readonly loginError = signal('');

  protected readonly form = this.formBuilder.nonNullable.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', Validators.required],
  });

  protected async enter(): Promise<void> {
    this.loginError.set('');
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const value = this.form.getRawValue();
    this.loggingIn.set(true);
    try {
      const response = await firstValueFrom(this.auth.login(value.email.trim(), value.password));
      this.auth.persist(response);
      await this.router.navigateByUrl('/roles');
    } catch (error) {
      this.loginError.set(readApiError(error));
    } finally {
      this.loggingIn.set(false);
    }
  }
}
