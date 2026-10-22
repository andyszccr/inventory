import { HttpClient } from '@angular/common/http';
import { inject, Injectable, signal } from '@angular/core';
import { Observable } from 'rxjs';

const TOKEN_KEY = 'inventory.token';
const USER_KEY = 'inventory.user';

export interface SessionUser {
  usuariosId: number;
  nombreCompleto: string;
  email: string;
  rol: string;
}

export interface LoginResponse {
  token: string;
  expiresAt: string;
  usuario: SessionUser;
}

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly http = inject(HttpClient);
  private readonly tokenState = signal<string | null>(sessionStorage.getItem(TOKEN_KEY));

  readonly user = signal<SessionUser | null>(readUser());

  token(): string | null {
    return this.tokenState();
  }

  login(email: string, password: string): Observable<LoginResponse> {
    return this.http.post<LoginResponse>('/api/auth/login', { email, password });
  }

  persist(response: LoginResponse): void {
    sessionStorage.setItem(TOKEN_KEY, response.token);
    sessionStorage.setItem(USER_KEY, JSON.stringify(response.usuario));
    this.tokenState.set(response.token);
    this.user.set(response.usuario);
  }

  logout(): void {
    sessionStorage.removeItem(TOKEN_KEY);
    sessionStorage.removeItem(USER_KEY);
    this.tokenState.set(null);
    this.user.set(null);
  }
}

function readUser(): SessionUser | null {
  const raw = sessionStorage.getItem(USER_KEY);
  if (!raw) {
    return null;
  }

  try {
    return JSON.parse(raw) as SessionUser;
  } catch {
    return null;
  }
}
