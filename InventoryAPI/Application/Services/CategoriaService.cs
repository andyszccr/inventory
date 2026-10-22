using Application.Interfaces;
using Application.Models;

namespace Application.Services;

public class CategoriaService(ICategoriaRepository categorias) : ICategoriaService
{
    public Task<IReadOnlyList<CategoriaListItem>> GetAsync(CancellationToken cancellationToken = default)
    {
        return categorias.GetAsync(cancellationToken);
    }

    public Task<CategoriaListItem?> GetByIdAsync(int categoriaId, CancellationToken cancellationToken = default)
    {
        if (categoriaId <= 0)
        {
            throw new ArgumentException("El identificador de la categoría es obligatorio.", nameof(categoriaId));
        }

        return categorias.GetByIdAsync(categoriaId, cancellationToken);
    }

    public Task InsertAsync(string categoriaName, string? categoriaDescription, CancellationToken cancellationToken = default)
    {
        var name = NormalizeName(categoriaName);
        var description = NormalizeDescription(categoriaDescription);

        return categorias.InsertAsync(name, description, cancellationToken);
    }

    public Task UpdateAsync(
        int categoriaId,
        string categoriaName,
        string? categoriaDescription,
        bool categoriasStatus,
        CancellationToken cancellationToken = default)
    {
        if (categoriaId <= 0)
        {
            throw new ArgumentException("El identificador de la categoría es obligatorio.", nameof(categoriaId));
        }

        var name = NormalizeName(categoriaName);
        var description = NormalizeDescription(categoriaDescription);

        return categorias.UpdateAsync(categoriaId, name, description, categoriasStatus, cancellationToken);
    }

    public Task DeleteAsync(int categoriaId, CancellationToken cancellationToken = default)
    {
        if (categoriaId <= 0)
        {
            throw new ArgumentException("El identificador de la categoría es obligatorio.", nameof(categoriaId));
        }

        return categorias.DeleteAsync(categoriaId, cancellationToken);
    }

    private static string NormalizeName(string categoriaName)
    {
        var name = categoriaName?.Trim() ?? string.Empty;

        if (name.Length == 0)
        {
            throw new ArgumentException("El nombre de la categoría es obligatorio.", nameof(categoriaName));
        }

        if (name.Length > 100)
        {
            throw new ArgumentException("El nombre de la categoría no puede superar 100 caracteres.", nameof(categoriaName));
        }

        return name;
    }

    private static string? NormalizeDescription(string? categoriaDescription)
    {
        if (string.IsNullOrWhiteSpace(categoriaDescription))
        {
            return null;
        }

        var description = categoriaDescription.Trim();

        if (description.Length > 250)
        {
            throw new ArgumentException("La descripción de la categoría no puede superar 250 caracteres.", nameof(categoriaDescription));
        }

        return description;
    }
}
