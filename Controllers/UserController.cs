using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Xml.Linq;

namespace DockerWebApiSampleApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        [HttpGet]
        [Route("get-all-users")]
        public async Task<IActionResult> Get()
        {
            var users = new
            {
                name = "Sagar",
                age = 30,
                currentTimestamp = DateTime.Now.Ticks
            };
            return Ok(users);
        }
    }
}
