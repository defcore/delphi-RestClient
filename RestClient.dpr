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
  RestClient.Core.Exceptions in 'Source\RestClient.Core.Exceptions.pas',
  SampleRestAPI in 'Demo\SampleRestAPI.pas',
  Sample.Classes in 'Demo\Sample.Classes.pas';

var
  todo : TTodo;
  todos : TObjectList<TTodo>;
  boolResult : TResponse;

  sampleRestAPI: ISampleRestClient;
begin
  try
    try
      sampleRestAPI := TRestClient.Resolve<ISampleRestClient>;

      todo := sampleRestAPI.GetTodo(1);
      Writeln(todo.Title);

      todos := sampleRestAPI.GetTodos;
      Writeln(todos.ToString);

      todo := TTodo.Create;
      todo.id := 1;
      todo.title := 'Test TODO';
      todo.userId := 1;
      todo.completed := false;

      boolResult := sampleRestAPI.CreateTodo(todo);
      Writeln(boolResult.ToString);
      
      todo := sampleRestAPI.GetTodo(1,'Alex');
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
