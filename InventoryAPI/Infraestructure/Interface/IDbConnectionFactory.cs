using System.Data;

namespace Infraestructure.Interface;

public interface IDbConnectionFactory
{
    IDbConnection CreateConnection();
}
