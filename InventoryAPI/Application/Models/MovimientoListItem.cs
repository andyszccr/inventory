namespace Application.Models;

public class MovimientoListItem
{
    public int MovimientoId { get; init; }

    public string CodigoProducto { get; init; } = string.Empty;

    public string NombreProducto { get; init; } = string.Empty;

    public int UsuariosId { get; init; }

    public string NombreUsuario { get; init; } = string.Empty;

    public string TipoMovimiento { get; init; } = string.Empty;

    public decimal Cantidad { get; init; }

    public decimal StockPrevio { get; init; }

    public decimal NuevoStock { get; init; }

    public string? Notas { get; init; }

    public string? Fecha { get; init; }
}
