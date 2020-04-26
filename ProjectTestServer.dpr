program ProjectTestServer;

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
  Server.Recources.Todos in 'Server.Recources.Todos.pas';

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
