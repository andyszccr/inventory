namespace Application.Models;

public class UsuarioCredentials
{
    public int UsuariosId { get; init; }

    public string NombreCompleto { get; init; } = string.Empty;

    public string Email { get; init; } = string.Empty;

    public string PasswordHash { get; init; } = string.Empty;

    public int RoleId { get; init; }

    public string Rol { get; init; } = string.Empty;

    public bool UsuarioStatus { get; init; }
}
