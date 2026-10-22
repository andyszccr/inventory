using Application.Models;

namespace Application.Interfaces;

public interface IUsuarioRepository
{
    Task<IReadOnlyList<UsuarioListItem>> GetAsync(CancellationToken cancellationToken = default);

    Task<UsuarioListItem?> GetByIdAsync(int usuariosId, CancellationToken cancellationToken = default);

    Task<UsuarioCredentials?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);

    Task InsertAsync(string nombreCompleto, string email, string passwordHash, int roleId, CancellationToken cancellationToken = default);

    Task UpdateAsync(int usuariosId, string nombreCompleto, string email, int roleId, bool usuarioStatus, CancellationToken cancellationToken = default);

    Task DeleteAsync(int usuariosId, CancellationToken cancellationToken = default);
}
