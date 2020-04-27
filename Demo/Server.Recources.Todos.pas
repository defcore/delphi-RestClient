unit Server.Recources.Todos;

interface

uses
  Sample,
  System.Generics.Collections,
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
  RestCaller;

type

[Path('/v1')]
 TTodoResource = class
  private
    [Context] Request: TWiRLRequest;
    [Context] AuthContext: TWiRLAuthContext;
  public
    [GET, Path('/todos')]
    [Produces(TMediaType.APPLICATION_JSON)]
    function GetTodos: TObjectList<TTodo>;

    [GET, Path('/todos/{id}')]
    [Produces(TMediaType.APPLICATION_JSON)]
    function GetTodo([PathParam] id: Integer): TTodo;

    [POST, Path('/todos')]
    [Produces(TMediaType.APPLICATION_JSON)]
    [Consumes(TMediaType.APPLICATION_JSON)]
    function CreateTodo([BodyParam] todo: TTodo): TResponse;

  end;


implementation

function TTodoResource.GetTodo([PathParam] id: Integer): TTodo;
begin
     Result := TTodo.Create;
     Result.id := 1;
     Result.title := 'Test TODO';
     Result.userId := 1;
     Result.completed := false;
end;

function TTodoResource.GetTodos: TObjectList<TTodo>;
var
  tmpTodo : TTodo;
  I: Integer;
begin
     Result := TObjectList<TTodo>.Create;

     for I := 0 to 10 do begin

       tmpTodo := TTodo.Create;
       tmpTodo.id := I;
       tmpTodo.title := 'Test TODO';
       tmpTodo.userId := I;
       tmpTodo.completed := false;

       Result.Add(tmpTodo);
     end;
end;

function TTodoResource.CreateTodo([BodyParam] todo: TTodo): TResponse;
begin
  Result := TResponse.Create;
  if (todo <> nil) then
    Result.Result := true
  else
    Result.Result := false;

  Writeln(todo.ToString);
end;


initialization
  TWiRLResourceRegistry.Instance.RegisterResource<TTodoResource>;
end.
