using Application.Models;

namespace Application.Interfaces;

public interface ICategoriaRepository
{
    Task<IReadOnlyList<CategoriaListItem>> GetAsync(CancellationToken cancellationToken = default);

    Task<CategoriaListItem?> GetByIdAsync(int categoriaId, CancellationToken cancellationToken = default);

    Task InsertAsync(string categoriaName, string? categoriaDescription, CancellationToken cancellationToken = default);

    Task UpdateAsync(int categoriaId, string categoriaName, string? categoriaDescription, bool categoriasStatus, CancellationToken cancellationToken = default);

    Task DeleteAsync(int categoriaId, CancellationToken cancellationToken = default);
}
