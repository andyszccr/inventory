namespace Application.Models;

public class Role
{
    public int RoleId { get; init; }

    public string RolesName { get; init; } = string.Empty;

    public string? RolesDescription { get; init; }

    public bool IsActive { get; init; }

    public DateTime? CreateDate { get; init; }
}
