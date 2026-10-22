namespace Application.Exceptions;

public class MovimientoOperationException : Exception
{
    public MovimientoOperationException(int errorNumber, string message, Exception innerException)
        : base(message, innerException)
    {
        ErrorNumber = errorNumber;
    }

    public int ErrorNumber { get; }
}
