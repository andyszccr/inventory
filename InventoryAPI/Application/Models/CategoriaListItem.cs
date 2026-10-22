namespace Application.Models;

public class CategoriaListItem
{
    public int CategoriaId { get; init; }

    public string Nombre { get; init; } = string.Empty;

    public string? Descripcion { get; init; }

    public string Estado { get; init; } = string.Empty;

    public string? FechaCreacion { get; init; }

    public string? FechaModificacion { get; init; }

    public string? FechaDesactivacion { get; init; }
}
