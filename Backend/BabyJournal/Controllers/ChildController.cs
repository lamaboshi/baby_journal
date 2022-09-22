using BabyJournal.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BabyJournal.Controllers;

[Route("api/[controller]")]
[Authorize]
public class ChildController : ControllerBase
{
    private readonly IChildService _childService;
    private readonly IMemoryService _memoryService;

    public ChildController(IChildService childService, IMemoryService memoryService)
    {
        _childService = childService;
        _memoryService = memoryService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var children = await _childService.GetChildren();
        return Ok(children);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        var child = await _childService.GetChild(id);
        return Ok(child);
    }

    [HttpPost]
    public async Task<IActionResult> Add([FromBody] AddChildRequest request)
    {
        var child = await _childService.AddChild(request);
        return Ok(child);
    }

    [HttpPut]
    public async Task<IActionResult> Edit([FromBody] EditChildRequest request)
    {
        var child = await _childService.EditChild(request);
        return Ok(child);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        await _childService.RemoveChild(id);
        return NoContent();
    }

    [HttpPost("parent")]
    public async Task<IActionResult> AddParent([FromBody] AddParentRequest request)
    {
        try
        {
            var child = await _childService.AddParent(request);
            return Ok(child);
        }
        catch (System.Exception e)
        {
            return BadRequest(e.Message);
        }
    }

    [HttpDelete("parent")]
    public async Task<IActionResult> DeleteParent([FromBody] RemoveParentRequest request)
    {
        var child = await _childService.RemoveParent(request);
        return Ok(child);
    }

    [HttpGet("{chidId}/memory")]
    public async Task<IActionResult> GetAllMemories(int chidId, [FromQuery] int Offset, [FromQuery] int limit = 25)
    {
        var result = await _memoryService.GetMemories(chidId, new PagedMemories { Limit = limit, Offset = Offset });
        return Ok(result);
    }

    [HttpGet("{chidId}/memory/random")]
    public async Task<IActionResult> GetRandomMemories(int chidId)
    {
        var result = await _memoryService.GetRandomMemories(chidId);
        return Ok(result);
    }
}

