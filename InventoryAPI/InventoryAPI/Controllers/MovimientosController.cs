using Application.Exceptions;
using Application.Interfaces;
using InventoryAPI.DTOs;
using Microsoft.AspNetCore.Mvc;

namespace InventoryAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MovimientosController(IMovimientoService movimientos) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () => Ok(await movimientos.GetAsync(cancellationToken)));
    }

    [HttpPost]
    public async Task<IActionResult> Insert(MovimientoRequest request, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await movimientos.InsertAsync(
                request.ProductoId,
                request.UsuariosId,
                request.MovementType,
                request.Cantidad,
                request.Notes,
                cancellationToken);

            return StatusCode(StatusCodes.Status201Created, new { message = "Movimiento registrado." });
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
        catch (MovimientoOperationException exception)
        {
            return exception.ErrorNumber switch
            {
                50001 or 50002 or 50005 => BadRequest(new { message = exception.Message }),
                50003 or 50004 => NotFound(new { message = exception.Message }),
                _ => StatusCode(StatusCodes.Status500InternalServerError, new { message = exception.Message })
            };
        }
    }
}
