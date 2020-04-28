program TestServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Types,
  WiRL.Console.Base,
  WiRL.Console.Factory,
  WiRL.Core.Engine,
  WiRL.http.Server,
  WiRL.http.Server.Indy,
  WiRL.Configuration.Core,
  WiRL.Configuration.Neon,
  Neon.Core.Types,
  Server.Recources.Todos in 'Demo\Server.Recources.Todos.pas',
  Sample in 'Demo\Sample.pas',
  RestClient.Core.Attributes in 'Source\RestClient.Core.Attributes.pas',
  RestClient.Core.Interceptor in 'Source\RestClient.Core.Interceptor.pas',
  RestClient.Core.RestCaller in 'Source\RestClient.Core.RestCaller.pas',
  RestClient.Core in 'Source\RestClient.Core.pas';

var
  WiRLConsole: TWiRLConsoleBase;

begin
  try
    WiRLConsole := TWiRLConsoleFactory.NewConsole(
      procedure (AServer: TWiRLServer)
      begin
        AServer
          .SetPort(8080)
          .SetThreadPoolSize(10)
          .AddEngine<TWiRLEngine>('/rest')
          .SetEngineName('WiRL HelloWorld')

          // Adds and configures an application
          .AddApplication('/app')
            .SetResources('*')
            .SetFilters('*')
            .Plugin.Configure<IWiRLConfigurationNeon>
              .SetUseUTCDate(True)
              .SetMemberCase(TNeonCase.SnakeCase)
              .BackToApp
        ;
      end
    );
    try
      WiRLConsole.Start;
    finally
      WiRLConsole.Free;
    end;

    ExitCode := 0;
  except
    on E: Exception do
    begin
      ExitCode := 1;
      TWiRLConsoleLogger.LogError('Exception: ' + E.Message);
    end;
  end;
end.

{
var
  FServer: TWiRLServer;
begin

  FServer := TWiRLServer.Create(nil);

  FServer
    .SetPort(8080)
    .SetThreadPoolSize(20)
    .AddEngine<TWiRLEngine>('/rest')
    .SetEngineName('ErgoMobileTime')
    .AddApplication('/v1')
      .SetResources('*')
      .SetFilters('*')
      .Plugin.Configure<IWiRLConfigurationNeon>
        .SetUseUTCDate(True)
        .SetMemberCase(TNeonCase.SnakeCase);


    REadln;


    WiRLConsole := TWiRLConsoleFactory.NewConsole(
      procedure (AServer: TWiRLServer)
      begin
        AServer
          .SetPort(8080)
          .SetThreadPoolSize(10)
          .AddEngine<TWiRLEngine>('/rest')
          .SetEngineName('WiRL HelloWorld')

          // Adds and configures an application
          .AddApplication('/app')
            .SetResources([
              'Server.Resources.THelloWorldResource',
              'Server.Resources.TEntityResource'])
        ;
      end
    );
    try
      WiRLConsole.Start;
    finally
      WiRLConsole.Free;
    end;

    ExitCode := 0;
end.
}
