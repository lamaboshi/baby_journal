using BabyJournal.Database;
using BabyJournal.Database.Models;
using BabyJournal.Extensions;
using Microsoft.EntityFrameworkCore;

namespace BabyJournal.Services;

public record AddMemoryRequest(int ChildId, string Image, DateTime At, string Title, string Text, double Weight, double length);
public record EditMemoryRequest(int Id, DateTime At, string Title, string Text, double Weight, double length);

public interface IMemoryService
{
    public Task<List<MemoryModel>> GetMemories(int childId);
    public Task<MemoryModel> GetMemory(int id);
    public Task AddMemory(AddMemoryRequest request);
    public Task EditMemory(EditMemoryRequest request);
    public Task RemoveMemory(int id);
}

public class MemoryService : IMemoryService
{

    private readonly IAppDbContext _context;
    private readonly IHttpContextAccessor _httpContext;

    public MemoryService(IAppDbContext context, IHttpContextAccessor httpContext)
    {
        _context = context;
        _httpContext = httpContext;
    }

    public async Task AddMemory(AddMemoryRequest request)
    {
        var child = await _context.Children.FindAsync(request.ChildId);
        var memory = new MemoryModel
        {
            At = request.At,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow,
            Child = child!,
            CreatedBy = _httpContext.UserId(),
            Image = request.Image,
            Length = request.length,
            Text = request.Text,
            Title = request.Title,
            Weight = request.Weight,
        };
        _context.Memories.Add(memory);
        await _context.SaveChangesAsync();
    }

    public async Task EditMemory(EditMemoryRequest request)
    {
        var memory = await _context.Memories.FirstAsync(c => c.Id == request.Id);
        memory.At = request.At;
        memory.UpdatedAt = DateTime.UtcNow;
        memory.Length = request.length;
        memory.Text = request.Text;
        memory.Title = request.Title;
        memory.Weight = request.Weight;
        await _context.SaveChangesAsync();
    }
    public async Task<List<MemoryModel>> GetMemories(int childId)
    {
        throw new NotImplementedException();
    }

    public async Task<MemoryModel> GetMemory(int id)
    {
        var memory = await _context.Memories.FirstAsync(c => c.Id == id);
        return memory;
    }

    public async Task RemoveMemory(int id)
    {
        var memory = await _context.Memories.FirstAsync(c => c.Id == id);
        _context.Memories.Remove(memory);
        await _context.SaveChangesAsync();
    }
}