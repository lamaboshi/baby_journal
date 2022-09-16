using BabyJournal.Database.Models;
using Microsoft.EntityFrameworkCore;

namespace BabyJournal.Database;

public interface IAppDbContext
{

    DbSet<UserModel> Users { get; set; }
    DbSet<ChildModel> Children { get; set; }
    DbSet<MemoryModel> Memories { get; set; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken = new());

    int SaveChanges();
}

public class AppDbContext : DbContext, IAppDbContext
{

    public AppDbContext(DbContextOptions options) : base(options) { }

    public DbSet<UserModel> Users { get; set; }
    public DbSet<ChildModel> Children { get; set; }
    public DbSet<MemoryModel> Memories { get; set; }


    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .Entity<UserModel>()
            .HasMany(u => u.Children)
            .WithMany(r => r.Parents);

        base.OnModelCreating(modelBuilder);
    }

}