import alertify from 'alertifyjs';

let ready = false;

function prepare(): void {
  if (ready) {
    return;
  }

  ready = true;
  alertify.defaults.glossary.title = 'Roles';
  alertify.defaults.glossary.ok = 'Aceptar';
  alertify.defaults.glossary.cancel = 'Cancelar';
}

export function alertOk(message: string): void {
  prepare();
  alertify.alert(message, () => {
    alertify.message('OK');
  });
}

export function confirmRemove(roleName: string, onok: () => void): void {
  prepare();
  alertify.confirm(`¿Eliminar el rol ${roleName}?`, onok, () => undefined);
}
