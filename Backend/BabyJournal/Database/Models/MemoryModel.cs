using System;

namespace BabyJournal.Database.Models;

public class MemoryModel
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public int ChildId { get; set; }
    public double Length { get; set; }
    public double Weight { get; set; }
    public String Image { get; set; }
    public String Text { get; set; }
    public String Title { get; set; }
    public DateTime At { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }

    public ChildModel Child { get; set; }
    public virtual UserModel User { get; set; }
}