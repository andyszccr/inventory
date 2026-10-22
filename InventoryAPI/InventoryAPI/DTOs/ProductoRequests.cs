using System.ComponentModel.DataAnnotations;

namespace InventoryAPI.DTOs;

public class ProductoRequest
{
    [Required]
    [MaxLength(50)]
    public string CodigoProducto { get; set; } = string.Empty;

    [Required]
    [MaxLength(150)]
    public string ProductoName { get; set; } = string.Empty;

    [MaxLength(500)]
    public string? ProductoDescription { get; set; }

    [Required]
    public int CategoriaId { get; set; }

    [Required]
    public decimal UnitPrice { get; set; }

    [Required]
    public decimal Stock { get; set; }

    [Required]
    public decimal MinimumStock { get; set; }

    [Required]
    public bool? ProductoStatus { get; set; }
}
