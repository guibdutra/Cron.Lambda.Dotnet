using Amazon.Lambda.CloudWatchEvents.ScheduledEvents;
using Amazon.Lambda.Core;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace Cron.Lambda.Dotnet;

public class Function
{
    public string FunctionHandler(ScheduledEvent input, ILambdaContext context)
    {
        string triggered = "Triggered - OK";
        
        Console.WriteLine(triggered);

        return triggered;
    }
}
