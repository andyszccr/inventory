namespace Application.Exceptions;

public class UsuarioOperationException : Exception
{
    public UsuarioOperationException(int errorNumber, string message, Exception innerException)
        : base(message, innerException)
    {
        ErrorNumber = errorNumber;
    }

    public int ErrorNumber { get; }
}
