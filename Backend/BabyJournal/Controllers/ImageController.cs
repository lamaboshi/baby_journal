using BabyJournal.Services.Sftp;
using BabyJournal.Services.Sftp.Types;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BabyJournal.Controllers;

[Route("api/[controller]")]
[Authorize]
public class ImagesController : ControllerBase
{
    private readonly ISftpService _sftpService;

    public ImagesController(ISftpService sftpService)
    {
        _sftpService = sftpService;
    }

    [HttpPost]
    public async Task<ActionResult<string>> UploadFile([FromQuery(Name = "childId")] int? childId)
    {

        if (childId == null)
        {
            return BadRequest("No Child was given");
        }

        var file = Request.Form.Files[0];
        if (file.Length <= 0)
        {
            return BadRequest("No files to upload");
        }

        // Prepare the file
        var fileExtension = Path.GetExtension(file.FileName);
        var fileName = $"{Guid.NewGuid()}{fileExtension}";
        var fileStream = new MemoryStream();
        await file.CopyToAsync(fileStream);
        fileStream.Position = 0;

        // Send it.
        await _sftpService.UploadFile(new SftpUploadRequest
        {
            File = fileStream,
            ToFolder = $"{childId}",
            ToFile = fileName
        });

        return Ok(new
        {
            Path = $"https://cdn.qlevar.de/baby/{childId}/{fileName}",
            fileExtension,
        });
    }

}

