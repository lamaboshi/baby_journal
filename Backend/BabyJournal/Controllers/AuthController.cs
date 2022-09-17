using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using BabyJournal.Database;
using BabyJournal.Database.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace BabyJournal.Controllers;
[Route("api/[controller]")]
public class AuthController : ControllerBase
{

    private readonly IAppDbContext _context;
    private readonly IConfiguration _configuration;

    public AuthController(IAppDbContext context, IConfiguration configuration)
    {
        _context = context;
        _configuration = configuration;
    }

    [HttpPost("sign-up")]
    public async Task<IActionResult> SignUp([FromBody] LoginModel user)
    {

        if (user == null || string.IsNullOrWhiteSpace(user.Email) || string.IsNullOrWhiteSpace(user.Name) || string.IsNullOrWhiteSpace(user.Password))
        {
            return BadRequest("Missing user name or password");
        }

        var exist = await _context.Users.AnyAsync(u => u.Email.ToUpper() == user.Email.ToUpper());
        if (exist) return BadRequest("User exists");

        await _context.Users.AddAsync(new UserModel
        {
            Email = user.Email,
            Name = user.Name,
            Password = user.Password,
        });
        await _context.SaveChangesAsync();

        return await LogIn(user);
    }

    [HttpPost("log-in")]
    public async Task<IActionResult> LogIn([FromBody] LoginModel user)
    {
        if (user == null || string.IsNullOrWhiteSpace(user.Email) || string.IsNullOrWhiteSpace(user.Password))
        {
            return BadRequest("Missing user name or password");
        }
        var model = await _context.Users.FirstOrDefaultAsync(u => u.Email.ToUpper() == user.Email.ToUpper() && u.Password == user.Password);
        if (model == null) return BadRequest("Unknown user");

        await _context.SaveChangesAsync();

        return Ok(new LoginModel
        {
            Name = user.Name,
            Email = user.Email,
            Token = CreateToken(model),
        });
    }

    [HttpGet("log-out")]
    [Authorize]
    public async Task<IActionResult> LogOut([FromQuery] string email)
    {
        if (string.IsNullOrWhiteSpace(email))
        {
            return BadRequest("Missing email");
        }
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email.ToUpper() == email.ToUpper());
        if (user == null) return NotFound();

        await _context.SaveChangesAsync();

        return NoContent();
    }

    private string CreateToken(UserModel user)
    {
        var claims = new Claim[] {
            new ("Id", user.Id.ToString()),
            new (ClaimTypes.Email, user.Email),
            new (ClaimTypes.Name, user.Name),
        };

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var subject = new ClaimsIdentity(claims);
        var descriptor = new SecurityTokenDescriptor
        {
            Subject = subject,
            SigningCredentials = credentials,
            IssuedAt = DateTime.UtcNow,
            Expires = DateTime.UtcNow.AddHours(3),
        };
        var handler = new JwtSecurityTokenHandler();
        var token = handler.CreateJwtSecurityToken(descriptor);
        return handler.WriteToken(token);
    }

}

public class LoginModel
{

    public string Email { get; set; }
    public string Name { get; set; }
    public string Password { get; set; }
    public string Token { get; set; }

}