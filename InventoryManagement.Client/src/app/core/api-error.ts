import { HttpErrorResponse } from '@angular/common/http';

export function readApiError(error: unknown): string {
  if (!(error instanceof HttpErrorResponse)) {
    return 'No se pudo completar la operación.';
  }

  if (error.status === 0) {
    return 'No se pudo conectar con el API.';
  }

  const body = error.error;
  if (typeof body === 'string' && body.trim() && body !== 'Failed to fetch') {
    return body;
  }

  if (body && typeof body === 'object') {
    const record = body as {
      message?: unknown;
      title?: unknown;
      errors?: Record<string, unknown>;
    };

    if (typeof record.message === 'string' && record.message.trim()) {
      return record.message;
    }

    const firstError = record.errors ? Object.values(record.errors)[0] : undefined;
    if (Array.isArray(firstError) && typeof firstError[0] === 'string') {
      return firstError[0];
    }

    if (typeof record.title === 'string' && record.title.trim()) {
      return record.title;
    }
  }

  return 'No se pudo completar la operación.';
}
