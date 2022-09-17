using System.IO;

namespace BabyJournal.Services.Sftp.Types
{

    public class SftpUploadRequest
    {

        public Stream File { get; set; }
        public string ToFile { get; set; }
        public string ToFolder { get; set; }

    }

}
