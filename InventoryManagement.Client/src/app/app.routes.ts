import { Routes } from '@angular/router';
import { authGuard } from './core/auth/auth.guard';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'roles' },
  {
    path: 'entrar',
    loadComponent: () => import('./core/auth/login-page').then((m) => m.LoginPage),
    title: 'Entrar',
  },
  {
    path: 'roles',
    canActivate: [authGuard],
    loadChildren: () => import('./features/roles/roles.routes').then((m) => m.ROLES_ROUTES),
  },
  {
    path: 'usuarios',
    canActivate: [authGuard],
    loadChildren: () => import('./features/users/users.routes').then((m) => m.USERS_ROUTES),
  },
  {
    path: 'categorias',
    canActivate: [authGuard],
    loadChildren: () => import('./features/categories/categories.routes').then((m) => m.CATEGORIES_ROUTES),
  },
  {
    path: 'productos',
    canActivate: [authGuard],
    loadChildren: () =>
      import('./features/products/products.routes').then((m) => m.PRODUCTS_ROUTES),
  },
  {
    path: 'movimientos',
    canActivate: [authGuard],
    loadChildren: () =>
      import('./features/movements/movements.routes').then((m) => m.MOVEMENTS_ROUTES),
  },
];
