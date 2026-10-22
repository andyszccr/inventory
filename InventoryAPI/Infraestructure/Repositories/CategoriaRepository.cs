using System.Data;
using Application.Exceptions;
using Application.Interfaces;
using Application.Models;
using Dapper;
using Infraestructure.Interface;
using Microsoft.Data.SqlClient;

namespace Infraestructure.Repositories;

public class CategoriaRepository(IDbConnectionFactory connectionFactory) : ICategoriaRepository
{
    public Task<IReadOnlyList<CategoriaListItem>> GetAsync(CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.CategoriasGet",
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var rows = await connection.QueryAsync(command);
            return (IReadOnlyList<CategoriaListItem>)rows.Select(row => MapListItem((object)row)).ToList();
        });
    }

    public Task<CategoriaListItem?> GetByIdAsync(int categoriaId, CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.CategoriasGetByID",
                new { CategoriaID = categoriaId },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var rows = (await connection.QueryAsync(command)).ToList();
            CategoriaListItem? categoria = rows.Count == 0 ? null : MapListItem((object)rows[0]);
            return categoria;
        });
    }

    public async Task InsertAsync(string categoriaName, string? categoriaDescription, CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.CategoriasInsert",
                new
                {
                    CategoriaName = categoriaName,
                    CategoriaDescription = categoriaDescription
                },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            await connection.ExecuteAsync(command);
            return 0;
        });
    }

    public async Task UpdateAsync(
        int categoriaId,
        string categoriaName,
        string? categoriaDescription,
        bool categoriasStatus,
        CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.CategoriasUpdate",
                new
                {
                    CategoriaID = categoriaId,
                    CategoriaName = categoriaName,
                    CategoriaDescription = categoriaDescription,
                    CategoriasStatus = categoriasStatus
                },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            await connection.ExecuteAsync(command);
            return 0;
        });
    }

    public async Task DeleteAsync(int categoriaId, CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.CategoriasDelete",
                new { CategoriaID = categoriaId },
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
            throw new CategoriaOperationException(exception.Number, exception.Message, exception);
        }
    }

    private static CategoriaListItem MapListItem(object row)
    {
        var data = (IDictionary<string, object>)row;

        return new CategoriaListItem
        {
            CategoriaId = Convert.ToInt32(data["Codigo Categoria"]),
            Nombre = ReadString(data, "Categoria") ?? string.Empty,
            Descripcion = ReadString(data, "Descripcion"),
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
}
