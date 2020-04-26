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
  Interceptors in 'Interceptors.pas',
  Sample in 'Sample.pas',
  Attributes in 'Attributes.pas',
  RestCaller in 'RestCaller.pas',
  RestClient.Core in 'RestClient.Core.pas';

var
  sampleRestClient: ISampleRestClient;

  todo : TTodo;
  todos : TObjectList<TTodo>;
  boolResult : TResponse;
begin
  try
    try
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

      Readln;
    finally
      FreeAndNil(todo);
      FreeAndNil(todos);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.