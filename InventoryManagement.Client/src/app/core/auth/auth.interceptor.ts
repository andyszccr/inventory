import { HttpInterceptorFn } from '@angular/common/http';

const TOKEN_KEY = 'inventory.token';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const token = sessionStorage.getItem(TOKEN_KEY);
  if (!token || !req.url.startsWith('/api/') || req.url.includes('/api/auth/login')) {
    return next(req);
  }

  return next(
    req.clone({
      setHeaders: { Authorization: `Bearer ${token}` },
    }),
  );
};
