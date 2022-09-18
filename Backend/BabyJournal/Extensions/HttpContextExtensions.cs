using System.Security.Claims;

namespace BabyJournal.Extensions
{

    public static class HttpContextExtensions
    {

        public static int UserId(this IHttpContextAccessor httpContextAccessor)
        {
            var id = httpContextAccessor?.HttpContext?.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (id == null) return 0;
            return int.Parse(id);
        }

    }

}
