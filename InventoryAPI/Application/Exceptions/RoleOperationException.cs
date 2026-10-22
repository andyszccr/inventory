namespace Application.Exceptions;

public class RoleOperationException : Exception
{
    public RoleOperationException(int errorNumber, string message, Exception innerException)
        : base(message, innerException)
    {
        ErrorNumber = errorNumber;
    }

    public int ErrorNumber { get; }
}
