using Application.Interfaces;
using Application.Models;

namespace Application.Services;

public class ProductoService(IProductoRepository productos) : IProductoService
{
    public Task<IReadOnlyList<ProductoListItem>> GetAsync(CancellationToken cancellationToken = default)
    {
        return productos.GetAsync(cancellationToken);
    }

    public Task<ProductoListItem?> GetByIdAsync(int productoId, CancellationToken cancellationToken = default)
    {
        ValidateId(productoId);
        return productos.GetByIdAsync(productoId, cancellationToken);
    }

    public Task InsertAsync(
        string codigoProducto,
        string productoName,
        string? productoDescription,
        int categoriaId,
        decimal unitPrice,
        decimal minimumStock,
        CancellationToken cancellationToken = default)
    {
        var codigo = NormalizeCodigo(codigoProducto);
        var name = NormalizeName(productoName);
        var description = NormalizeDescription(productoDescription);
        ValidateCategoria(categoriaId);
        ValidateAmounts(unitPrice, minimumStock);

        return productos.InsertAsync(codigo, name, description, categoriaId, unitPrice, minimumStock, cancellationToken);
    }

    public Task UpdateAsync(
        int productoId,
        string codigoProducto,
        string productoName,
        string? productoDescription,
        int categoriaId,
        decimal unitPrice,
        decimal minimumStock,
        bool productoStatus,
        CancellationToken cancellationToken = default)
    {
        ValidateId(productoId);
        var codigo = NormalizeCodigo(codigoProducto);
        var name = NormalizeName(productoName);
        var description = NormalizeDescription(productoDescription);
        ValidateCategoria(categoriaId);
        ValidateAmounts(unitPrice, minimumStock);

        return productos.UpdateAsync(
            productoId,
            codigo,
            name,
            description,
            categoriaId,
            unitPrice,
            minimumStock,
            productoStatus,
            cancellationToken);
    }

    public Task DeleteAsync(int productoId, CancellationToken cancellationToken = default)
    {
        ValidateId(productoId);
        return productos.DeleteAsync(productoId, cancellationToken);
    }

    private static void ValidateId(int productoId)
    {
        if (productoId <= 0)
        {
            throw new ArgumentException("El identificador del producto es obligatorio.", nameof(productoId));
        }
    }

    private static string NormalizeCodigo(string codigoProducto)
    {
        var codigo = codigoProducto?.Trim() ?? string.Empty;

        if (codigo.Length == 0)
        {
            throw new ArgumentException("El código del producto es obligatorio.", nameof(codigoProducto));
        }

        if (codigo.Length > 50)
        {
            throw new ArgumentException("El código del producto no puede superar 50 caracteres.", nameof(codigoProducto));
        }

        return codigo;
    }

    private static string NormalizeName(string productoName)
    {
        var name = productoName?.Trim() ?? string.Empty;

        if (name.Length == 0)
        {
            throw new ArgumentException("El nombre del producto es obligatorio.", nameof(productoName));
        }

        if (name.Length > 150)
        {
            throw new ArgumentException("El nombre del producto no puede superar 150 caracteres.", nameof(productoName));
        }

        return name;
    }

    private static string? NormalizeDescription(string? productoDescription)
    {
        if (string.IsNullOrWhiteSpace(productoDescription))
        {
            return null;
        }

        var description = productoDescription.Trim();

        if (description.Length > 500)
        {
            throw new ArgumentException("La descripción del producto no puede superar 500 caracteres.", nameof(productoDescription));
        }

        return description;
    }

    private static void ValidateCategoria(int categoriaId)
    {
        if (categoriaId <= 0)
        {
            throw new ArgumentException("La categoría es obligatoria.", nameof(categoriaId));
        }
    }

    private static void ValidateAmounts(decimal unitPrice, decimal minimumStock)
    {
        if (unitPrice < 0)
        {
            throw new ArgumentException("El precio no puede ser negativo.", nameof(unitPrice));
        }

        if (minimumStock < 0)
        {
            throw new ArgumentException("El stock mínimo no puede ser negativo.", nameof(minimumStock));
        }
    }
}
