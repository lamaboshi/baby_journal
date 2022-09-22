using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BabyJournal.Migrations
{
    public partial class AddUserIdToMemeory : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "CreatedBy",
                table: "Memories",
                newName: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Memories_UserId",
                table: "Memories",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Memories_Users_UserId",
                table: "Memories",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Memories_Users_UserId",
                table: "Memories");

            migrationBuilder.DropIndex(
                name: "IX_Memories_UserId",
                table: "Memories");

            migrationBuilder.RenameColumn(
                name: "UserId",
                table: "Memories",
                newName: "CreatedBy");
        }
    }
}
