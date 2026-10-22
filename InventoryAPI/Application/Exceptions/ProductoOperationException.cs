namespace Application.Exceptions;

public class ProductoOperationException : Exception
{
    public ProductoOperationException(int errorNumber, string message, Exception innerException)
        : base(message, innerException)
    {
        ErrorNumber = errorNumber;
    }

    public int ErrorNumber { get; }
}
