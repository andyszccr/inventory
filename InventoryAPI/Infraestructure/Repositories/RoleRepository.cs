using System.Data;
using Application.Exceptions;
using Application.Interfaces;
using Application.Models;
using Dapper;
using Infraestructure.Interface;
using Microsoft.Data.SqlClient;

namespace Infraestructure.Repositories;

public class RoleRepository(IDbConnectionFactory connectionFactory) : IRoleRepository
{
    public Task<IReadOnlyList<RoleListItem>> GetAsync(int roleId, CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.RolesGet",
                new { RoleID = roleId },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var rows = await connection.QueryAsync(command);
            return (IReadOnlyList<RoleListItem>)rows.Select(MapListItem).ToList();
        });
    }

    public Task<RoleListItem?> GetByIdAsync(int roleId, CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.RolesGetByID",
                new { RoleID = roleId },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var rows = (await connection.QueryAsync(command)).ToList();
            RoleListItem? role = rows.Count == 0 ? null : MapListItem((object)rows[0]);
            return role;
        });
    }

    public Task<Role> InsertAsync(string rolesName, string? rolesDescription, CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.RolesInsert",
                new { RolesName = rolesName, RolesDescription = rolesDescription },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var created = await connection.QuerySingleAsync<RoleInsertRow>(command);
            return new Role
            {
                RoleId = created.RoleID,
                RolesName = created.RolesName,
                RolesDescription = created.RolesDescription,
                IsActive = created.IsActive,
                CreateDate = created.CreateDate
            };
        });
    }

    public async Task UpdateAsync(
        int roleId,
        string rolesName,
        string? rolesDescription,
        bool isActive,
        CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.RolesUpdate",
                new
                {
                    RoleID = roleId,
                    RolesName = rolesName,
                    RolesDescription = rolesDescription,
                    IsActive = isActive
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
            throw new RoleOperationException(exception.Number, exception.Message, exception);
        }
    }

    private static RoleListItem MapListItem(object row)
    {
        var data = (IDictionary<string, object>)row;

        return new RoleListItem
        {
            RoleId = ReadInt(data, "Roles ID"),
            Nombre = ReadString(data, "Nombre ROl") ?? string.Empty,
            Descripcion = ReadString(data, "Descripción"),
            Estado = ReadString(data, "Estado") ?? string.Empty,
            FechaCreacion = ReadString(data, "Fecha de creacion"),
            FechaModificacion = ReadString(data, "Fecha de modificacion"),
            FechaDesactivacion = ReadString(data, "Fecha de desactivacion")
        };
    }

    private static int ReadInt(IDictionary<string, object> row, string column)
    {
        return Convert.ToInt32(row[column]);
    }

    private static string? ReadString(IDictionary<string, object> row, string column)
    {
        if (!row.TryGetValue(column, out var value) || value is null or DBNull)
        {
            return null;
        }

        return Convert.ToString(value);
    }

    private sealed class RoleInsertRow
    {
        public int RoleID { get; set; }

        public string RolesName { get; set; } = string.Empty;

        public string? RolesDescription { get; set; }

        public bool IsActive { get; set; }

        public DateTime? CreateDate { get; set; }
    }
}
