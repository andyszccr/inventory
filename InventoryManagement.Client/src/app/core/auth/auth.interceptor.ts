import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { catchError, throwError } from 'rxjs';
import { AuthService } from './auth.service';

const TOKEN_KEY = 'inventory.token';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const auth = inject(AuthService);
  const router = inject(Router);
  const token = sessionStorage.getItem(TOKEN_KEY);
  const authed =
    token && req.url.startsWith('/api/') && !req.url.includes('/api/auth/login')
      ? req.clone({ setHeaders: { Authorization: `Bearer ${token}` } })
      : req;

  return next(authed).pipe(
    catchError((error: unknown) => {
      if (
        error instanceof HttpErrorResponse &&
        error.status === 401 &&
        !req.url.includes('/api/auth/login')
      ) {
        auth.logout();
        void router.navigateByUrl('/entrar');
      }

      return throwError(() => error);
    }),
  );
};
