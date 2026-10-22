using Application.Interfaces;
using Application.Models;

namespace Application.Services;

public class RoleService(IRoleRepository roles) : IRoleService
{
    public Task<IReadOnlyList<RoleListItem>> GetAsync(CancellationToken cancellationToken = default)
    {
        return roles.GetAsync(roleId: 0, cancellationToken);
    }

    public Task<RoleListItem?> GetByIdAsync(int roleId, CancellationToken cancellationToken = default)
    {
        if (roleId <= 0)
        {
            throw new ArgumentException("El identificador del rol es obligatorio.", nameof(roleId));
        }

        return roles.GetByIdAsync(roleId, cancellationToken);
    }

    public Task<Role> InsertAsync(string rolesName, string? rolesDescription, CancellationToken cancellationToken = default)
    {
        var name = NormalizeName(rolesName);
        var description = NormalizeDescription(rolesDescription);

        return roles.InsertAsync(name, description, cancellationToken);
    }

    public Task UpdateAsync(
        int roleId,
        string rolesName,
        string? rolesDescription,
        bool isActive,
        CancellationToken cancellationToken = default)
    {
        if (roleId <= 0)
        {
            throw new ArgumentException("El identificador del rol es obligatorio.", nameof(roleId));
        }

        var name = NormalizeName(rolesName);
        var description = NormalizeDescription(rolesDescription);

        return roles.UpdateAsync(roleId, name, description, isActive, cancellationToken);
    }

    public Task DeleteAsync(int roleId, CancellationToken cancellationToken = default)
    {
        if (roleId <= 0)
        {
            throw new ArgumentException("El identificador del rol es obligatorio.", nameof(roleId));
        }

        return roles.DeleteAsync(roleId, cancellationToken);
    }

    private static string NormalizeName(string rolesName)
    {
        var name = rolesName?.Trim() ?? string.Empty;

        if (name.Length == 0)
        {
            throw new ArgumentException("El nombre del rol es obligatorio.", nameof(rolesName));
        }

        if (name.Length > 50)
        {
            throw new ArgumentException("El nombre del rol no puede superar 50 caracteres.", nameof(rolesName));
        }

        return name;
    }

    private static string? NormalizeDescription(string? rolesDescription)
    {
        if (string.IsNullOrWhiteSpace(rolesDescription))
        {
            return null;
        }

        var description = rolesDescription.Trim();

        if (description.Length > 200)
        {
            throw new ArgumentException("La descripción del rol no puede superar 200 caracteres.", nameof(rolesDescription));
        }

        return description;
    }
}
