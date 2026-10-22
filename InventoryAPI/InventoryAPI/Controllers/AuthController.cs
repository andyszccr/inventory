using Application.Interfaces;
using InventoryAPI.DTOs;
using InventoryAPI.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace InventoryAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController(IUsuarioService usuarios, JwtTokenGenerator tokenGenerator) : ControllerBase
{
    [AllowAnonymous]
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest request, CancellationToken cancellationToken)
    {
        try
        {
            var user = await usuarios.LoginAsync(request.Email, request.Password, cancellationToken);
            var (token, expiresAt) = tokenGenerator.CreateToken(user);

            return Ok(new
            {
                token,
                expiresAt,
                usuario = new
                {
                    user.UsuariosId,
                    user.NombreCompleto,
                    user.Email,
                    user.Rol
                }
            });
        }
        catch (ArgumentException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
        catch (UnauthorizedAccessException exception)
        {
            return Unauthorized(new { message = exception.Message });
        }
    }
}
