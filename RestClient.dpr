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
  response : TResponse;

  sampleRestAPI: ISampleRestClient;
begin
  try
    try

      sampleRestAPI := GlobalRestClient.Resolve<ISampleRestClient>;

      todo := sampleRestAPI.GetTodo(1);

      Writeln(todo.Title);




      todos := sampleRestAPI.GetTodos;
      Writeln(todos.ToString);

      //PathParam samples
      todo := sampleRestAPI.GetTodo(1,'Alex');
      Writeln(todo.Title);

      //BodyParam samples
      todo := TTodo.Create;
      todo.id := 1;
      todo.title := 'Test TODO';
      todo.userId := 1;
      todo.completed := false;

      response := sampleRestAPI.CreateTodo(todo);
      Writeln(response.ToString);

      //QueryParam samples
      todo := sampleRestAPI.GetPerson(1);
      Writeln(todo.Title);

      todo := sampleRestAPI.GetPerson(1, 'Alex');
      Writeln(todo.Title);

     { try
        todo := sampleRestAPI.RaiseException;
      Except on E: Exception do begin
        Writeln(E.Message);
      end;

      end;  }

      Readln;
    finally
      FreeAndNil(todo);
      FreeAndNil(todos);
      FreeAndNil(response);
    end;
  except
    on E: Exception do BEGIN
      Writeln(E.ClassName, ': ', E.Message);
       Readln;
    END;
  end;
end.
