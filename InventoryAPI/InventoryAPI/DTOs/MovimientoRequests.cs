using System.ComponentModel.DataAnnotations;

namespace InventoryAPI.DTOs;

public class MovimientoRequest
{
    [Required]
    public int ProductoId { get; set; }

    [Required]
    public int UsuariosId { get; set; }

    [Required]
    [MaxLength(20)]
    public string MovementType { get; set; } = string.Empty;

    [Required]
    public decimal Cantidad { get; set; }

    [MaxLength(500)]
    public string? Notes { get; set; }
}
