using Application.Exceptions;
using Application.Interfaces;
using InventoryAPI.DTOs;
using Microsoft.AspNetCore.Mvc;

namespace InventoryAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CategoriasController(ICategoriaService categorias) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () => Ok(await categorias.GetAsync(cancellationToken)));
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            var categoria = await categorias.GetByIdAsync(id, cancellationToken);
            return categoria is null ? NotFound(new { message = "La categoría no existe." }) : Ok(categoria);
        });
    }

    [HttpPost]
    public async Task<IActionResult> Insert(CategoriaRequest request, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await categorias.InsertAsync(request.CategoriaName, request.CategoriaDescription, cancellationToken);
            return StatusCode(StatusCodes.Status201Created, new { message = "Categoría creada." });
        });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, CategoriaRequest request, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await categorias.UpdateAsync(
                id,
                request.CategoriaName,
                request.CategoriaDescription,
                request.CategoriasStatus!.Value,
                cancellationToken);

            return NoContent();
        });
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await categorias.DeleteAsync(id, cancellationToken);
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
        catch (CategoriaOperationException exception)
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
