using System.ComponentModel.DataAnnotations;

namespace InventoryAPI.DTOs;

public class RoleRequest
{
    [Required]
    [MaxLength(50)]
    public string RolesName { get; set; } = string.Empty;

    [MaxLength(200)]
    public string? RolesDescription { get; set; }

    public bool? IsActive { get; set; }
}
