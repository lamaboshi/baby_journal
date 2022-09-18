using BabyJournal.Database;
using BabyJournal.Database.Models;
using BabyJournal.Extensions;
using Microsoft.EntityFrameworkCore;

namespace BabyJournal.Services;


public record AddChildRequest(string Name, DateTime Birthday);
public record EditChildRequest(int Id, string Name, DateTime Birthday);
public record AddParentRequest(int childId, string ParentEmail);
public record RemoveParentRequest(int childId, int ParentId);

public interface IChildService
{

    public Task<List<ChildModel>> GetChildren();
    public Task<ChildModel> GetChild(int id);
    public Task<ChildModel> AddChild(AddChildRequest request);
    public Task<ChildModel> EditChild(EditChildRequest request);
    public Task RemoveChild(int id);
    public Task<ChildModel> AddParent(AddParentRequest request);
    public Task<ChildModel> RemoveParent(RemoveParentRequest request);

}

public class ChildService : IChildService
{
    private readonly IAppDbContext _context;
    private readonly IHttpContextAccessor _httpContext;

    public ChildService(IAppDbContext context, IHttpContextAccessor httpContext)
    {
        _context = context;
        _httpContext = httpContext;
    }

    public async Task<ChildModel> AddChild(AddChildRequest request)
    {
        var parent = await _context.Users.FindAsync(_httpContext.UserId());
        var child = new ChildModel
        {
            Birthday = request.Birthday,
            Name = request.Name,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow,
            Parents = new List<UserModel> {
                parent,
            }
        };
        _context.Children.Add(child);
        await _context.SaveChangesAsync();
        return child;
    }

    public async Task<ChildModel> AddParent(AddParentRequest request)
    {
        var child = await _context.Children.Include(c => c.Parents).FirstAsync(c => c.Id == request.childId);
        var parent = await _context.Users.FirstAsync(u => u.Email == request.ParentEmail);
        throw new Exception("No user found with this email");
        child.Parents.Remove(parent);
        await _context.SaveChangesAsync();
        return child;
    }

    public async Task<ChildModel> EditChild(EditChildRequest request)
    {
        var child = await _context.Children.FirstAsync(c => c.Id == request.Id);
        child.Name = request.Name;
        child.Birthday = request.Birthday;
        child.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        return child;
    }

    public async Task<ChildModel> GetChild(int id)
    {
        var child = await _context.Children.Include(c => c.Parents).FirstAsync(c => c.Id == id);
        return child;
    }

    public async Task RemoveChild(int id)
    {
        var child = await _context.Children.FirstAsync(c => c.Id == id);
        _context.Children.Remove(child);
        await _context.SaveChangesAsync();
    }

    public async Task<List<ChildModel>> GetChildren()
    {
        var id = _httpContext.UserId();
        var parent = await _context.Users.Include(u => u.Children).FirstAsync(u => u.Id == id);
        return parent.Children.ToList();
    }

    public async Task<ChildModel> RemoveParent(RemoveParentRequest request)
    {
        var child = await _context.Children.Include(c => c.Parents).FirstAsync(c => c.Id == request.childId);
        var parent = await _context.Users.FindAsync(request.ParentId);
        child.Parents.Remove(parent);
        await _context.SaveChangesAsync();
        return child;
    }

}