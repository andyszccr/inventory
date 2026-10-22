using Application.Interfaces;
using Application.Models;

namespace Application.Services;

public class MovimientoService(IMovimientoRepository movimientos) : IMovimientoService
{
    private static readonly string[] MovementTypes = ["ENTRADA", "SALIDA", "AJUSTE"];

    public Task<IReadOnlyList<MovimientoListItem>> GetAsync(CancellationToken cancellationToken = default)
    {
        return movimientos.GetAsync(cancellationToken);
    }

    public Task InsertAsync(
        int productoId,
        int usuariosId,
        string movementType,
        decimal cantidad,
        string? notes,
        CancellationToken cancellationToken = default)
    {
        if (productoId <= 0)
        {
            throw new ArgumentException("El producto es obligatorio.", nameof(productoId));
        }

        if (usuariosId <= 0)
        {
            throw new ArgumentException("El usuario es obligatorio.", nameof(usuariosId));
        }

        var tipo = NormalizeMovementType(movementType);
        if (cantidad <= 0)
        {
            throw new ArgumentException("La cantidad debe ser mayor que cero.", nameof(cantidad));
        }

        var notas = NormalizeNotes(notes);
        return movimientos.InsertAsync(productoId, usuariosId, tipo, cantidad, notas, cancellationToken);
    }

    private static string NormalizeMovementType(string movementType)
    {
        var tipo = movementType?.Trim().ToUpperInvariant() ?? string.Empty;
        if (!MovementTypes.Contains(tipo))
        {
            throw new ArgumentException("Tipo de movimiento inválido. Use ENTRADA, SALIDA o AJUSTE.", nameof(movementType));
        }

        return tipo;
    }

    private static string? NormalizeNotes(string? notes)
    {
        if (string.IsNullOrWhiteSpace(notes))
        {
            return null;
        }

        var value = notes.Trim();
        if (value.Length > 500)
        {
            throw new ArgumentException("Las notas no pueden superar 500 caracteres.", nameof(notes));
        }

        return value;
    }
}
