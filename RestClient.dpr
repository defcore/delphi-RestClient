program RestClient;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections,
  Spring,
  Spring.Container,
  Spring.Container.Common,
  Spring.Interception,
  System.Rtti,

  RestClient.Core.Attributes in 'Source\RestClient.Core.Attributes.pas',
  RestClient.Core.Interceptor in 'Source\RestClient.Core.Interceptor.pas',
  RestClient.Core.RestCaller in 'Source\RestClient.Core.RestCaller.pas',
  RestClient.Core in 'Source\RestClient.Core.pas',
  Sample in 'Demo\Sample.pas',
  RestClient.Core.Exceptions in 'Source\RestClient.Core.Exceptions.pas',
  SampleRestAPI in 'DemoWithMock\SampleRestAPI.pas',
  RestClient.Core.RestConnection in 'Source\RestClient.Core.RestConnection.pas';

var
  sampleRestClient: ISampleRestClient;

  todo : TTodo;
  todos : TObjectList<TTodo>;
  boolResult : TResponse;

  restAPI: ISampleRestClientMock;
begin
  try
    try
    {
      GlobalRestClient.RegisterClient<ISampleRestClient, TSampleRestClient>;
      sampleRestClient := GlobalRestClient.Resolve<ISampleRestClient>;

      todo := sampleRestClient.GetTodo(1);
      Writeln(todo.Title);

      todos := sampleRestClient.GetTodos;
      Writeln(todos.ToString);

      todo := TTodo.Create;
      todo.id := 1;
      todo.title := 'Test TODO';
      todo.userId := 1;
      todo.completed := false;

      boolResult := sampleRestClient.CreateTodo(todo);
      Writeln(boolResult.ToString);
      }


      // Mock test
      //restAPI := TProxyGenerator.CreateInterfaceProxyWithoutTarget<ISampleRestClientMock>(TRestClientInterceptor.Create());
      restAPI := RestClient<ISampleRestClientMock>.Resolve;

      restAPI := RestClient2.Resolve<ISampleRestClientMock>;

      todo := restAPI.GetTodo(1,'Alex');
      Writeln(todo.Title);

      Readln;
    finally
      FreeAndNil(todo);
      FreeAndNil(todos);
    end;
  except
    on E: Exception do BEGIN
      Writeln(E.ClassName, ': ', E.Message);
       Readln;
    END;
  end;
end.
