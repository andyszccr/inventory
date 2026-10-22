using System.Data;
using Application.Exceptions;
using Application.Interfaces;
using Application.Models;
using Dapper;
using Infraestructure.Interface;
using Microsoft.Data.SqlClient;

namespace Infraestructure.Repositories;

public class UsuarioRepository(IDbConnectionFactory connectionFactory) : IUsuarioRepository
{
    public Task<IReadOnlyList<UsuarioListItem>> GetAsync(CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.UsuariosGet",
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var rows = await connection.QueryAsync(command);
            return (IReadOnlyList<UsuarioListItem>)rows.Select(row => MapListItem((object)row)).ToList();
        });
    }

    public Task<UsuarioListItem?> GetByIdAsync(int usuariosId, CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.UsuariosGetByID",
                new { UsuariosID = usuariosId },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var rows = (await connection.QueryAsync(command)).ToList();
            UsuarioListItem? usuario = rows.Count == 0 ? null : MapListItem((object)rows[0]);
            return usuario;
        });
    }

    public Task<UsuarioCredentials?> GetByEmailAsync(string email, CancellationToken cancellationToken = default)
    {
        return ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.UsuariosGetByEmail",
                new { Email = email },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            var row = await connection.QuerySingleOrDefaultAsync<UsuarioLoginRow>(command);
            if (row is null)
            {
                return null;
            }

            return new UsuarioCredentials
            {
                UsuariosId = row.UsuariosID,
                NombreCompleto = row.NombreCompleto,
                Email = row.Email,
                PasswordHash = row.PasswordHash,
                RoleId = row.RoleId,
                Rol = row.RolesName,
                UsuarioStatus = row.UsuarioStatus
            };
        });
    }

    public async Task InsertAsync(
        string nombreCompleto,
        string email,
        string passwordHash,
        int roleId,
        CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.UsuariosInsert",
                new
                {
                    NombreCompleto = nombreCompleto,
                    Email = email,
                    PasswordHash = passwordHash,
                    RoleId = roleId
                },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            await connection.ExecuteAsync(command);
            return 0;
        });
    }

    public async Task UpdateAsync(
        int usuariosId,
        string nombreCompleto,
        string email,
        int roleId,
        bool usuarioStatus,
        CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.UsuariosUpdate",
                new
                {
                    UsuariosID = usuariosId,
                    NombreCompleto = nombreCompleto,
                    Email = email,
                    RoleId = roleId,
                    UsuarioStatus = usuarioStatus
                },
                commandType: CommandType.StoredProcedure,
                cancellationToken: cancellationToken);

            await connection.ExecuteAsync(command);
            return 0;
        });
    }

    public async Task DeleteAsync(int usuariosId, CancellationToken cancellationToken = default)
    {
        await ExecuteAsync(async () =>
        {
            using var connection = connectionFactory.CreateConnection();
            var command = new CommandDefinition(
                "dbo.UsuariosDelete",
                new { UsuariosID = usuariosId },
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
            throw new UsuarioOperationException(exception.Number, exception.Message, exception);
        }
    }

    private static UsuarioListItem MapListItem(object row)
    {
        var data = (IDictionary<string, object>)row;

        return new UsuarioListItem
        {
            UsuariosId = Convert.ToInt32(data["Codigo Usuario"]),
            NombreCompleto = ReadString(data, "Nombre de Usuario") ?? string.Empty,
            Email = ReadString(data, "Correo electronico") ?? string.Empty,
            Rol = ReadString(data, "Rol") ?? string.Empty,
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

    private sealed class UsuarioLoginRow
    {
        public int UsuariosID { get; set; }

        public string NombreCompleto { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        public string PasswordHash { get; set; } = string.Empty;

        public int RoleId { get; set; }

        public string RolesName { get; set; } = string.Empty;

        public bool UsuarioStatus { get; set; }
    }
}
