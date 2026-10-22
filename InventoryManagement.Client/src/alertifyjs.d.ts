declare module 'alertifyjs' {
  interface Alertify {
    alert(message: string, onok?: () => void): Alertify;
    message(message: string): Alertify;
    confirm(message: string, onok?: () => void, oncancel?: () => void): Alertify;
    defaults: {
      glossary: {
        title: string;
        ok: string;
        cancel: string;
      };
    };
  }

  const alertify: Alertify;
  export default alertify;
}
