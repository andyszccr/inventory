using System.Net.Mail;
using Application.Interfaces;
using Application.Models;
using Application.Security;

namespace Application.Services;

public class UsuarioService(IUsuarioRepository usuarios, IPasswordHasher passwordHasher) : IUsuarioService
{
    private static readonly string DummyPasswordHash = new Pbkdf2PasswordHasher().Hash("inventario-dummy");

    public Task<IReadOnlyList<UsuarioListItem>> GetAsync(CancellationToken cancellationToken = default)
    {
        return usuarios.GetAsync(cancellationToken);
    }

    public Task<UsuarioListItem?> GetByIdAsync(int usuariosId, CancellationToken cancellationToken = default)
    {
        if (usuariosId <= 0)
        {
            throw new ArgumentException("El identificador del usuario es obligatorio.", nameof(usuariosId));
        }

        return usuarios.GetByIdAsync(usuariosId, cancellationToken);
    }

    public Task InsertAsync(
        string nombreCompleto,
        string email,
        string password,
        int roleId,
        CancellationToken cancellationToken = default)
    {
        var name = NormalizeName(nombreCompleto);
        var normalizedEmail = NormalizeEmail(email);
        ValidatePassword(password);
        ValidateRole(roleId);

        var passwordHash = passwordHasher.Hash(password);
        return usuarios.InsertAsync(name, normalizedEmail, passwordHash, roleId, cancellationToken);
    }

    public Task UpdateAsync(
        int usuariosId,
        string nombreCompleto,
        string email,
        int roleId,
        bool usuarioStatus,
        CancellationToken cancellationToken = default)
    {
        if (usuariosId <= 0)
        {
            throw new ArgumentException("El identificador del usuario es obligatorio.", nameof(usuariosId));
        }

        var name = NormalizeName(nombreCompleto);
        var normalizedEmail = NormalizeEmail(email);
        ValidateRole(roleId);

        return usuarios.UpdateAsync(usuariosId, name, normalizedEmail, roleId, usuarioStatus, cancellationToken);
    }

    public Task DeleteAsync(int usuariosId, CancellationToken cancellationToken = default)
    {
        if (usuariosId <= 0)
        {
            throw new ArgumentException("El identificador del usuario es obligatorio.", nameof(usuariosId));
        }

        return usuarios.DeleteAsync(usuariosId, cancellationToken);
    }

    public async Task<AuthenticatedUser> LoginAsync(string email, string password, CancellationToken cancellationToken = default)
    {
        var normalizedEmail = NormalizeEmail(email);
        if (string.IsNullOrEmpty(password))
        {
            throw new UnauthorizedAccessException("Credenciales inválidas.");
        }

        var credentials = await usuarios.GetByEmailAsync(normalizedEmail, cancellationToken);
        var hash = credentials?.PasswordHash ?? DummyPasswordHash;
        var passwordMatches = passwordHasher.Verify(password, hash);

        if (credentials is null || !credentials.UsuarioStatus || !passwordMatches)
        {
            throw new UnauthorizedAccessException("Credenciales inválidas.");
        }

        return new AuthenticatedUser
        {
            UsuariosId = credentials.UsuariosId,
            NombreCompleto = credentials.NombreCompleto,
            Email = credentials.Email,
            RoleId = credentials.RoleId,
            Rol = credentials.Rol
        };
    }

    private static string NormalizeName(string nombreCompleto)
    {
        var name = nombreCompleto?.Trim() ?? string.Empty;
        if (name.Length == 0)
        {
            throw new ArgumentException("El nombre completo es obligatorio.", nameof(nombreCompleto));
        }

        if (name.Length > 150)
        {
            throw new ArgumentException("El nombre completo no puede superar 150 caracteres.", nameof(nombreCompleto));
        }

        return name;
    }

    private static string NormalizeEmail(string email)
    {
        var normalized = email?.Trim() ?? string.Empty;
        if (normalized.Length == 0)
        {
            throw new ArgumentException("El correo electrónico es obligatorio.", nameof(email));
        }

        if (normalized.Length > 150)
        {
            throw new ArgumentException("El correo electrónico no puede superar 150 caracteres.", nameof(email));
        }

        try
        {
            var address = new MailAddress(normalized);
            if (address.Address != normalized)
            {
                throw new ArgumentException("El correo electrónico no es válido.", nameof(email));
            }
        }
        catch (FormatException)
        {
            throw new ArgumentException("El correo electrónico no es válido.", nameof(email));
        }

        return normalized;
    }

    private static void ValidatePassword(string password)
    {
        if (string.IsNullOrWhiteSpace(password) || password.Length < 8)
        {
            throw new ArgumentException("La contraseña debe tener al menos 8 caracteres.", nameof(password));
        }

        if (password.Length > 100)
        {
            throw new ArgumentException("La contraseña no puede superar 100 caracteres.", nameof(password));
        }
    }

    private static void ValidateRole(int roleId)
    {
        if (roleId <= 0)
        {
            throw new ArgumentException("El rol es obligatorio.", nameof(roleId));
        }
    }
}
