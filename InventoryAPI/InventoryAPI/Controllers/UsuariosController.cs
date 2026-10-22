using Application.Exceptions;
using Application.Interfaces;
using InventoryAPI.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace InventoryAPI.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class UsuariosController(IUsuarioService usuarios) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () => Ok(await usuarios.GetAsync(cancellationToken)));
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            var usuario = await usuarios.GetByIdAsync(id, cancellationToken);
            return usuario is null ? NotFound(new { message = "El usuario no existe." }) : Ok(usuario);
        });
    }

    [AllowAnonymous]
    [HttpPost]
    public async Task<IActionResult> Insert(CreateUsuarioRequest request, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await usuarios.InsertAsync(request.NombreCompleto, request.Email, request.Password, request.RoleId, cancellationToken);
            return StatusCode(StatusCodes.Status201Created, new { message = "Usuario creado." });
        });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, UpdateUsuarioRequest request, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await usuarios.UpdateAsync(
                id,
                request.NombreCompleto,
                request.Email,
                request.RoleId,
                request.UsuarioStatus!.Value,
                cancellationToken);

            return NoContent();
        });
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await usuarios.DeleteAsync(id, cancellationToken);
            return NoContent();
        });
    }

    private async Task<IActionResult> ExecuteAsync(Func<Task<IActionResult>> action)
    {
        try
        {
            return await action();
        }
        catch (ArgumentException exception)
        {
            return BadRequest(new { message = exception.Message });
        }
        catch (UsuarioOperationException exception)
        {
            return exception.ErrorNumber switch
            {
                50001 or 50002 or 50003 or 50005 => BadRequest(new { message = exception.Message }),
                50004 => Conflict(new { message = exception.Message }),
                50006 => NotFound(new { message = exception.Message }),
                _ => StatusCode(StatusCodes.Status500InternalServerError, new { message = exception.Message })
            };
        }
    }
}
