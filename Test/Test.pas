unit Test;

interface
uses
 System.Classes,
  DUnitX.TestFramework,
  WiRL.Core.Engine,
  WiRL.Core.Application,
  WiRL.Core.Registry,
  WiRL.Core.Attributes,
  WiRL.http.Accept.MediaType,
  WiRL.http.URL,
  WiRL.Core.MessageBody.Default,
  WiRL.Core.Auth.Context,
  WiRL.http.Request,
  WiRL.http.Response,
  Interceptors,
  Sample,
  RestCaller;


type

  [TestFixture]
  TTestRestClient = class(TObject)
  public
    FServerThread: TThread;

    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;


implementation

uses
  Spring,
  Spring.Container,
  Spring.Container.Common,
  Spring.Interception,
  JOSE.Core.JWA,
  Neon.Core.Types,
  WiRL.http.Server,
  WiRL.http.Server.Indy,
  WiRL.Configuration.Core,
  WiRL.Configuration.Neon,
  WiRL.Configuration.JWT,
  WiRL.Console.Base,
  WiRL.Console.Factory;



procedure TTestRestClient.Setup;
//var
   //WiRLConsole: TWiRLConsoleBase;
begin
  FServerThread := TThread.CreateAnonymousThread(procedure ()
  var WiRLConsole: TWiRLConsoleBase;
  begin


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
        ;
      end
    );
    try
      WiRLConsole.Start;
    finally
      WiRLConsole.Free;
    end;
  end);
  FServerThread.Start;
end;

procedure TTestRestClient.TearDown;
begin
  FServerThread.Terminate;
  FServerThread.Free;
end;

procedure TTestRestClient.Test1;
var
  todo : TTodo;
  sample : ISampleRestClient;
begin
  GlobalContainer.RegisterType<IInterceptor, TRestClientInterceptor>('client');
  GlobalContainer.RegisterType<ISampleRestClient, TSampleRestClient>;
  GlobalContainer.Build;

  sample := GlobalContainer.Resolve<ISampleRestClient>;

  todo := sample.GetTodo(1);

  Assert.IsNotNull(todo, 'Todo is null');
  Assert.AreEqual(todo.id, 1);

  Writeln(todo.Title);
end;

procedure TTestRestClient.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestRestClient);
end.
