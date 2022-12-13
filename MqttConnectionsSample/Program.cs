using MqttConnectionsSample;
using System.Diagnostics;

Trace.Listeners.Add(new ConsoleTraceListener());

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        services.AddHostedService<Worker>();
    })
    .Build();

host.Run();
