namespace Application.Exceptions;

public class CategoriaOperationException : Exception
{
    public CategoriaOperationException(int errorNumber, string message, Exception innerException)
        : base(message, innerException)
    {
        ErrorNumber = errorNumber;
    }

    public int ErrorNumber { get; }
}
