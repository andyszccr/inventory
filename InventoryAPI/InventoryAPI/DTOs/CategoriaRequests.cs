using System.ComponentModel.DataAnnotations;

namespace InventoryAPI.DTOs;

public class CategoriaRequest
{
    [Required]
    [MaxLength(100)]
    public string CategoriaName { get; set; } = string.Empty;

    [MaxLength(250)]
    public string? CategoriaDescription { get; set; }

    [Required]
    public bool? CategoriasStatus { get; set; }
}
