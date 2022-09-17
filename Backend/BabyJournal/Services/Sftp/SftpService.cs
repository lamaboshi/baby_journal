using BabyJournal.Services.Sftp.Types;
using Renci.SshNet;
using Renci.SshNet.Sftp;

namespace BabyJournal.Services.Sftp
{

    /// <summary>
    /// BabyJournal.Services.Sftp.ISftpService
    /// 
    /// </summary>
    public interface ISftpService
    {

        /// <summary>
        /// Sends the specified request.
        /// </summary>
        /// <param name="request">The request.</param>
        Task UploadFile(SftpUploadRequest request);

        /// <summary>
        /// Deletes the file.
        /// </summary>
        /// <param name="remoteFilePath">The remote file path.</param>
        void DeleteFile(string remoteFilePath);

        List<SftpFile> ListAllFiles(string[] remoteDirectory);
        void DeleteFile(string[] remoteFilePath);
    }

    public class SftpService : ISftpService
    {
        private readonly ILogger<SftpService> _logger;

        private readonly SftpSettings _settings;

        public SftpService(IConfiguration configuration, ILogger<SftpService> logger)
        {
            _logger = logger;
            _settings = configuration.GetSection("SftpSettings").Get<SftpSettings>();
        }

        public Task UploadFile(SftpUploadRequest request)
        {

            if (_settings == null)
            {
                throw new NullReferenceException("SftpSettings are null");
            }

            return Task.Run(() =>
            {
                using var client = new SftpClient(_settings.HostName, _settings.UserName, _settings.Password);
                var to = $"{request.ToFolder}/{request.ToFile}";
                try
                {
                    client.Connect();
                    var folder = $"CDN/baby/{request.ToFolder}";
                    if (client.Exists(folder) == false)
                    {
                        client.CreateDirectory(folder);
                    }

                    client.UploadFile(request.File, $"{folder}/{request.ToFile}");
                    _logger.LogInformation($"Finished uploading file [{to}]");
                }
                catch (Exception exception)
                {
                    _logger.LogError(exception, $"Failed in uploading file [{to}]");
                }
                finally
                {
                    client.Disconnect();
                    request.File.Dispose();
                }
            });

        }

        public IEnumerable<SftpFile> ListAllFiles(string remoteDirectory = ".")
        {
            using var client = new SftpClient(_settings.HostName, _settings.UserName, _settings.Password);
            try
            {
                client.Connect();
                return client.ListDirectory(remoteDirectory);
            }
            catch (Exception exception)
            {
                _logger.LogError(exception, $"Failed in listing files under [{remoteDirectory}]");
                return null;
            }
            finally
            {
                client.Disconnect();
            }
        }

        public List<SftpFile> ListAllFiles(string[] remoteDirectory)
        {
            using var client = new SftpClient(_settings.HostName, _settings.UserName, _settings.Password);
            try
            {
                client.Connect();
                return remoteDirectory.SelectMany(n => client.ListDirectory(n)).ToList();
            }
            catch (Exception exception)
            {
                _logger.LogError(exception, $"Failed in listing files under [{remoteDirectory}]");
                return null;
            }
            finally
            {
                client.Disconnect();
            }
        }

        public void UploadFile(string localFilePath, string remoteFilePath)
        {
            using var client = new SftpClient(_settings.HostName, _settings.UserName, _settings.Password);
            try
            {
                client.Connect();
                using var s = File.OpenRead(localFilePath);
                client.UploadFile(s, remoteFilePath);
                _logger.LogInformation($"Finished uploading file [{localFilePath}] to [{remoteFilePath}]");
            }
            catch (Exception exception)
            {
                _logger.LogError(exception, $"Failed in uploading file [{localFilePath}] to [{remoteFilePath}]");
            }
            finally
            {
                client.Disconnect();
            }
        }

        public void DownloadFile(string remoteFilePath, string localFilePath)
        {
            using var client = new SftpClient(_settings.HostName, _settings.UserName, _settings.Password);
            try
            {
                client.Connect();
                using var s = File.Create(localFilePath);
                client.DownloadFile(remoteFilePath, s);
                _logger.LogInformation($"Finished downloading file [{localFilePath}] from [{remoteFilePath}]");
            }
            catch (Exception exception)
            {
                _logger.LogError(exception, $"Failed in downloading file [{localFilePath}] from [{remoteFilePath}]");
            }
            finally
            {
                client.Disconnect();
            }
        }

        public void DeleteFile(string remoteFilePath)
        {
            using var client = new SftpClient(_settings.HostName, _settings.UserName, _settings.Password);
            try
            {
                client.Connect();
                client.DeleteFile(remoteFilePath);
                _logger.LogInformation($"File [{remoteFilePath}] deleted.");
            }
            catch (Exception exception)
            {
                _logger.LogError(exception, $"Failed in deleting file [{remoteFilePath}]");
            }
            finally
            {
                client.Disconnect();
            }
        }

        public void DeleteFile(string[] remoteFilePath)
        {
            using var client = new SftpClient(_settings.HostName, _settings.UserName, _settings.Password);
            try
            {
                client.Connect();
                foreach (var files in remoteFilePath)
                {
                    client.DeleteFile(files);
                    _logger.LogInformation($"File [{files}] deleted.");
                }
            }
            catch (Exception exception)
            {
                _logger.LogError(exception, $"Failed in deleting file [{remoteFilePath}]");
            }
            finally
            {
                client.Disconnect();
            }
        }

    }

}
