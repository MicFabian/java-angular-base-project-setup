import { Route } from '@angular/router';

export const appRoutes: Route[] = [
  {
    path: '',
    title: 'Base Project',
    loadComponent: () =>
      import('./pages/home/home.page').then(
        (module) => module.HomePageComponent,
      ),
  },
];
