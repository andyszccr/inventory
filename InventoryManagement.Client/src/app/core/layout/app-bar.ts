import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { AuthService } from '../auth/auth.service';

@Component({
  selector: 'app-bar',
  imports: [RouterLink, RouterLinkActive],
  templateUrl: './app-bar.html',
  styleUrl: './app-bar.css',
})
export class AppBar {
  protected readonly auth = inject(AuthService);

  protected logout(): void {
    this.auth.logout();
  }
}
