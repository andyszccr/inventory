using System.Data;
using Application.Exceptions;
using Application.Interfaces;
using Application.Models;
using Dapper;
using Infraestructure.Interface;
using Microsoft.Data.SqlClient;

namespace Infraestructure.Repositories;

public class MovimientoRepository(IDbConnectionFactory connectionFactory) : IMovimientoRepository
{
    public Task<IReadOnlyList<MovimientoListItem>> GetAsync(CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.MovimientosInventarioGet",
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var rows = await connection.QueryAsync(command);
            return (IReadOnlyList<MovimientoListItem>)rows.Select(row => MapListItem((object)row)).ToList();
        });
    }

    public async Task InsertAsync(
        int productoId,
        int usuariosId,
        string movementType,
        decimal cantidad,
        string? notes,
        CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.MovimientosInventarioInsert",
                new
                {
                    ProductoID = productoId,
                    UsuariosID = usuariosId,
                    MovementType = movementType,
                    Cantidad = cantidad,
                    Notes = notes
                },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            await connection.ExecuteAsync(command);
            return 0;
        });
    }

    private static async Task<T> ExecuteAsync<T>(Func<Task<T>> action)
    {
        try
        {
            return await action();
        }
        catch (SqlException exception)
        {
            throw new MovimientoOperationException(exception.Number, exception.Message, exception);
        }
    }

    private static MovimientoListItem MapListItem(object row)
    {
        var data = (IDictionary<string, object>)row;

        return new MovimientoListItem
        {
            MovimientoId = Convert.ToInt32(data["codigo de movimiento"]),
            CodigoProducto = ReadString(data, "codigo de producto") ?? string.Empty,
            NombreProducto = ReadString(data, "Nombre de producto") ?? string.Empty,
            UsuariosId = Convert.ToInt32(data["codigo de usuario"]),
            NombreUsuario = ReadString(data, "Nombre de usuario") ?? string.Empty,
            TipoMovimiento = ReadString(data, "tipo de movimiento") ?? string.Empty,
            Cantidad = ReadDecimal(data, "cantidad"),
            StockPrevio = ReadDecimal(data, "stock previo"),
            NuevoStock = ReadDecimal(data, "NewStock"),
            Notas = ReadString(data, "Notes"),
            Fecha = ReadString(data, "Fecha de desactivacion")
        };
    }

    private static string? ReadString(IDictionary<string, object> row, string column)
    {
        if (!row.TryGetValue(column, out var value) || value is null or DBNull)
        {
            return null;
        }

        return Convert.ToString(value);
    }

    private static decimal ReadDecimal(IDictionary<string, object> row, string column)
    {
        if (!row.TryGetValue(column, out var value) || value is null or DBNull)
        {
            return 0;
        }

        return Convert.ToDecimal(value);
    }
}
