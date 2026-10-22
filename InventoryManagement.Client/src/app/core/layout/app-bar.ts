import { Component, inject } from '@angular/core';
import { Router, RouterLink, RouterLinkActive } from '@angular/router';
import { AuthService } from '../auth/auth.service';

@Component({
  selector: 'app-bar',
  imports: [RouterLink, RouterLinkActive],
  templateUrl: './app-bar.html',
  styleUrl: './app-bar.css',
})
export class AppBar {
  protected readonly auth = inject(AuthService);
  private readonly router = inject(Router);

  protected logout(): void {
    this.auth.logout();
    void this.router.navigateByUrl('/entrar');
  }
}
