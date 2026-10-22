using Application.Exceptions;
using Application.Interfaces;
using InventoryAPI.DTOs;
using Microsoft.AspNetCore.Mvc;

namespace InventoryAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class RolesController(IRoleService roles) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () => Ok(await roles.GetAsync(cancellationToken)));
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            var role = await roles.GetByIdAsync(id, cancellationToken);
            return role is null ? NotFound(new { message = "El rol no existe." }) : Ok(role);
        });
    }

    [HttpPost]
    public async Task<IActionResult> Insert(RoleRequest request, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            var created = await roles.InsertAsync(request.RolesName, request.RolesDescription, cancellationToken);
            return CreatedAtAction(nameof(GetById), new { id = created.RoleId }, created);
        });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, RoleRequest request, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await roles.UpdateAsync(id, request.RolesName, request.RolesDescription, request.IsActive!.Value, cancellationToken);
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
        catch (RoleOperationException exception)
        {
            return exception.ErrorNumber switch
            {
                50001 => BadRequest(new { message = exception.Message }),
                50002 => Conflict(new { message = exception.Message }),
                50003 => NotFound(new { message = exception.Message }),
                _ => StatusCode(StatusCodes.Status500InternalServerError, new { message = exception.Message })
            };
        }
    }
}
