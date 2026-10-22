import { Routes } from '@angular/router';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'roles' },
  {
    path: 'roles',
    loadChildren: () => import('./features/roles/roles.routes').then((m) => m.ROLES_ROUTES),
  },
  {
    path: 'usuarios',
    loadChildren: () => import('./features/users/users.routes').then((m) => m.USERS_ROUTES),
  },
  {
    path: 'categorias',
    loadChildren: () => import('./features/categories/categories.routes').then((m) => m.CATEGORIES_ROUTES),
  },
  {
    path: 'productos',
    loadChildren: () =>
      import('./features/products/products.routes').then((m) => m.PRODUCTS_ROUTES),
  },
];
