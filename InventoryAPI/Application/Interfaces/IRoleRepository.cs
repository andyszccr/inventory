using Application.Models;

namespace Application.Interfaces;

public interface IRoleRepository
{
    Task<IReadOnlyList<RoleListItem>> GetAsync(int roleId, CancellationToken cancellationToken = default);

    Task<RoleListItem?> GetByIdAsync(int roleId, CancellationToken cancellationToken = default);

    Task<Role> InsertAsync(string rolesName, string? rolesDescription, CancellationToken cancellationToken = default);

    Task UpdateAsync(int roleId, string rolesName, string? rolesDescription, bool isActive, CancellationToken cancellationToken = default);

    Task DeleteAsync(int roleId, CancellationToken cancellationToken = default);
}
