using System.Data;
using Application.Exceptions;
using Application.Interfaces;
using Application.Models;
using Dapper;
using Infraestructure.Interface;
using Microsoft.Data.SqlClient;

namespace Infraestructure.Repositories;

public class ProductoRepository(IDbConnectionFactory connectionFactory) : IProductoRepository
{
    public Task<IReadOnlyList<ProductoListItem>> GetAsync(CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.ProductosGet",
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var rows = await connection.QueryAsync(command);
            return (IReadOnlyList<ProductoListItem>)rows.Select(row => MapListItem((object)row)).ToList();
        });
    }

    public Task<ProductoListItem?> GetByIdAsync(int productoId, CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.ProductosGetByID",
                new { ProductoID = productoId },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var rows = (await connection.QueryAsync(command)).ToList();
            ProductoListItem? producto = rows.Count == 0 ? null : MapListItem((object)rows[0]);
            return producto;
        });
    }

    public async Task InsertAsync(
        string codigoProducto,
        string productoName,
        string? productoDescription,
        int categoriaId,
        decimal unitPrice,
        decimal stock,
        decimal minimumStock,
        CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.ProductosInsert",
                new
                {
                    CodigoProducto = codigoProducto,
                    ProductoName = productoName,
                    ProductoDescription = productoDescription,
                    CategoriaID = categoriaId,
                    UnitPrice = unitPrice,
                    Stock = stock,
                    MinimumStock = minimumStock
                },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            await connection.ExecuteAsync(command);
            return 0;
        });
    }

    public async Task UpdateAsync(
        int productoId,
        string codigoProducto,
        string productoName,
        string? productoDescription,
        int categoriaId,
        decimal unitPrice,
        decimal stock,
        decimal minimumStock,
        bool productoStatus,
        CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.ProductosUpdate",
                new
                {
                    ProductoID = productoId,
                    CodigoProducto = codigoProducto,
                    ProductoName = productoName,
                    ProductoDescription = productoDescription,
                    CategoriaID = categoriaId,
                    UnitPrice = unitPrice,
                    Stock = stock,
                    MinimumStock = minimumStock,
                    ProductoStatus = productoStatus
                },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            await connection.ExecuteAsync(command);
            return 0;
        });
    }

    public async Task DeleteAsync(int productoId, CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.ProductosDelete",
                new { ProductoID = productoId },
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
            throw new ProductoOperationException(exception.Number, exception.Message, exception);
        }
    }

    private static ProductoListItem MapListItem(object row)
    {
        var data = (IDictionary<string, object>)row;

        return new ProductoListItem
        {
            ProductoId = Convert.ToInt32(data["Producto ID"]),
            Codigo = ReadString(data, "Codigo de producto") ?? string.Empty,
            Nombre = ReadString(data, "Nombre de Producto") ?? string.Empty,
            Descripcion = ReadString(data, "Descripcion"),
            Categoria = ReadString(data, "Categoria") ?? string.Empty,
            PrecioUnitario = ReadDecimal(data, "Precio Unitario"),
            Stock = ReadDecimal(data, "Stock"),
            StockMinimo = ReadDecimal(data, "Stock minimo"),
            Estado = ReadString(data, "Estado") ?? string.Empty,
            FechaCreacion = ReadString(data, "Fecha de creacion"),
            FechaModificacion = ReadString(data, "Fecha de modificacion"),
            FechaDesactivacion = ReadString(data, "Fecha de desactivacion")
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
