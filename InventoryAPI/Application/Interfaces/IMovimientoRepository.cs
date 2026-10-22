using Application.Models;

namespace Application.Interfaces;

public interface IMovimientoRepository
{
    Task<IReadOnlyList<MovimientoListItem>> GetAsync(CancellationToken cancellationToken = default);

    Task InsertAsync(
        int productoId,
        int usuariosId,
        string movementType,
        decimal cantidad,
        string? notes,
        CancellationToken cancellationToken = default);
}
