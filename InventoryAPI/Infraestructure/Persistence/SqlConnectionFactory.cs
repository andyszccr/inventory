using System.Data;
using Infraestructure.Interface;
using Microsoft.Data.SqlClient;

namespace Infraestructure.Persistence;

public class SqlConnectionFactory(string connectionString) : IDbConnectionFactory
{
    public IDbConnection CreateConnection()
    {
        return new SqlConnection(connectionString);
    }
}
