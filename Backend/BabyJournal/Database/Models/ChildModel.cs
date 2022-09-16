namespace BabyJournal.Database.Models;

public class ChildModel
{
    public int Id { get; set; }
    public String Name { get; set; }
    public DateTime Birthday { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }

    public ICollection<UserModel> Parents { get; set; } = new List<UserModel>();
    public ICollection<MemoryModel> Memories { get; set; } = new List<MemoryModel>();
}