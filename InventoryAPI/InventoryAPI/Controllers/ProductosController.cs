using Application.Exceptions;
using Application.Interfaces;
using InventoryAPI.DTOs;
using Microsoft.AspNetCore.Mvc;

namespace InventoryAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductosController(IProductoService productos) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () => Ok(await productos.GetAsync(cancellationToken)));
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            var producto = await productos.GetByIdAsync(id, cancellationToken);
            return producto is null ? NotFound(new { message = "El producto no existe." }) : Ok(producto);
        });
    }

    [HttpPost]
    public async Task<IActionResult> Insert(ProductoRequest request, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await productos.InsertAsync(
                request.CodigoProducto,
                request.ProductoName,
                request.ProductoDescription,
                request.CategoriaId,
                request.UnitPrice,
                request.Stock,
                request.MinimumStock,
                cancellationToken);

            return StatusCode(StatusCodes.Status201Created, new { message = "Producto creado." });
        });
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, ProductoRequest request, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await productos.UpdateAsync(
                id,
                request.CodigoProducto,
                request.ProductoName,
                request.ProductoDescription,
                request.CategoriaId,
                request.UnitPrice,
                request.Stock,
                request.MinimumStock,
                request.ProductoStatus!.Value,
                cancellationToken);

            var updated = await productos.GetByIdAsync(id, cancellationToken);
            return Ok(updated);
        });
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken)
    {
        return await ExecuteAsync(async () =>
        {
            await productos.DeleteAsync(id, cancellationToken);
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
        catch (ProductoOperationException exception)
        {
            return exception.ErrorNumber switch
            {
                50001 or 50002 or 50003 or 50004 or 50006 => BadRequest(new { message = exception.Message }),
                50005 => Conflict(new { message = exception.Message }),
                50007 => NotFound(new { message = exception.Message }),
                _ => StatusCode(StatusCodes.Status500InternalServerError, new { message = exception.Message })
            };
        }
    }
}
