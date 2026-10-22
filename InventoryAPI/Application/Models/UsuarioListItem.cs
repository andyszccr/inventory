namespace Application.Models;

public class UsuarioListItem
{
    public int UsuariosId { get; init; }

    public string NombreCompleto { get; init; } = string.Empty;

    public string Email { get; init; } = string.Empty;

    public string Rol { get; init; } = string.Empty;

    public string Estado { get; init; } = string.Empty;

    public string? FechaCreacion { get; init; }

    public string? FechaModificacion { get; init; }

    public string? FechaDesactivacion { get; init; }
}
