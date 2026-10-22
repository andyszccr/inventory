namespace Application.Models;

public class ProductoListItem
{
    public string Codigo { get; init; } = string.Empty;

    public string Nombre { get; init; } = string.Empty;

    public string? Descripcion { get; init; }

    public string Categoria { get; init; } = string.Empty;

    public decimal PrecioUnitario { get; init; }

    public decimal Stock { get; init; }

    public decimal StockMinimo { get; init; }

    public string Estado { get; init; } = string.Empty;

    public string? FechaCreacion { get; init; }

    public string? FechaModificacion { get; init; }

    public string? FechaDesactivacion { get; init; }
}
