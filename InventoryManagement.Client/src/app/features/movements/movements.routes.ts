import { Routes } from '@angular/router';

export const MOVEMENTS_ROUTES: Routes = [
  {
    path: '',
    loadComponent: () =>
      import('./pages/movements-page/movements-page').then((m) => m.MovementsPage),
    title: 'Movimientos',
  },
];
