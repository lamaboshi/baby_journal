using BabyJournal.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BabyJournal.Controllers;

[Route("api/[controller]")]
[Authorize]
public class MemoryController : ControllerBase
{
    private readonly IMemoryService _memoryService;

    public MemoryController(IMemoryService memoryService)
    {
        _memoryService = memoryService;
    }

    [HttpGet(":id")]
    public async Task<IActionResult> GetMemory(int id)
    {
        var memory = await _memoryService.GetMemory(id);
        return NoContent();
    }

    [HttpPost]
    public async Task<IActionResult> AddMemory(AddMemoryRequest request)
    {
        await _memoryService.AddMemory(request);
        return NoContent();
    }

    [HttpPut("/:id")]
    public async Task<IActionResult> EditMemory(EditMemoryRequest request)
    {
        await _memoryService.EditMemory(request);
        return NoContent();
    }

    [HttpDelete("/:id")]
    public async Task<IActionResult> DeleteMemory(int id)
    {
        await _memoryService.RemoveMemory(id);
        return NoContent();
    }
}

