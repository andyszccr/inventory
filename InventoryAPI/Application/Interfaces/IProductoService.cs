using Application.Models;

namespace Application.Interfaces;

public interface IProductoService
{
    Task<IReadOnlyList<ProductoListItem>> GetAsync(CancellationToken cancellationToken = default);

    Task<ProductoListItem?> GetByIdAsync(int productoId, CancellationToken cancellationToken = default);

    Task InsertAsync(
        string codigoProducto,
        string productoName,
        string? productoDescription,
        int categoriaId,
        decimal unitPrice,
        decimal stock,
        decimal minimumStock,
        CancellationToken cancellationToken = default);

    Task UpdateAsync(
        int productoId,
        string codigoProducto,
        string productoName,
        string? productoDescription,
        int categoriaId,
        decimal unitPrice,
        decimal stock,
        decimal minimumStock,
        bool productoStatus,
        CancellationToken cancellationToken = default);

    Task DeleteAsync(int productoId, CancellationToken cancellationToken = default);
}
