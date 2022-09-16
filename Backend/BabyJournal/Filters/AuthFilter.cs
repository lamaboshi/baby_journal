using BabyJournal.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ChatBackend.Filters;

public class AuthRequirement : IAuthorizationRequirement { }

public class AuthHandler : AuthorizationHandler<AuthRequirement>
{
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly IAppDbContext _context;
    private readonly IConfiguration _configuration;

    public AuthHandler(IHttpContextAccessor httpContextAccessor, IAppDbContext context, IConfiguration configuration)
    {
        _httpContextAccessor = httpContextAccessor;
        _context = context;
        _configuration = configuration;
    }

    protected override async Task HandleRequirementAsync(AuthorizationHandlerContext context, AuthRequirement requirement)
    {

        var token = _httpContextAccessor?.HttpContext?.Request.Headers["Authorization"].FirstOrDefault()?.Split(" ").Last();

        // Try get hub token
        if (string.IsNullOrEmpty(token))
        {
            token = _httpContextAccessor?.HttpContext?.Request.Query["access_token"];
        }

        if (string.IsNullOrEmpty(token))
        {
            context.Fail();
            return;
        }

        try
        {

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_configuration["JWT:Key"]);
            tokenHandler.ValidateToken(token, new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = false,
                ValidateAudience = false,
                ClockSkew = TimeSpan.Zero
            }, out SecurityToken validatedToken);

            var jwtToken = (JwtSecurityToken)validatedToken;
            var userId = int.Parse(jwtToken.Claims.First(x => x.Type == "Id").Value);
            var user = await _context.Users.FindAsync(userId);

            if (user == null)
            {
                context.Fail();
                return;
            }

            var claims = new List<Claim>() {
                new (ClaimTypes.NameIdentifier, user.Id.ToString()),
                new (ClaimTypes.Name, user.Name),
                new (ClaimTypes.Email, user.Email),
            };

            _httpContextAccessor!.HttpContext!.User.AddIdentity(new ClaimsIdentity(claims));
            context.Succeed(requirement);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            context.Fail();
        }

    }

}