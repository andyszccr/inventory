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
];
