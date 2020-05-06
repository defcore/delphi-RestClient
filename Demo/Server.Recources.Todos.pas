unit Server.Recources.Todos;

interface

uses
  Sample.Classes,
  System.Generics.Collections,
  WiRL.Core.Engine,
  WiRL.Core.Application,
  WiRL.Core.Registry,
  WiRL.Core.Attributes,
  WiRL.http.Accept.MediaType,
  WiRL.http.URL,
  WiRL.Core.MessageBody.Default,
  WiRL.Core.Auth.Context,
  WiRL.Core.Exceptions,
  WiRL.http.Request,
  WiRL.http.Response;

type

[Path('/v1')]
 TTodoResource = class
  private
    [Context] Request: TWiRLRequest;

  public
    [GET, Path('/todos')]
    [Produces(TMediaType.APPLICATION_JSON)]
    function GetTodos: TObjectList<TTodo>;

    [GET, Path('/todos/{id}')]
    [Produces(TMediaType.APPLICATION_JSON)]
    function GetTodo([PathParam] id: Integer): TTodo; overload;

    [GET, Path('/todos/{id}/name/{name}')]
    [Produces(TMediaType.APPLICATION_JSON)]
    function GetTodo([PathParam] id: Integer; [PathParam] name: String): TTodo; overload;

    [POST, Path('/todos')]
    [Produces(TMediaType.APPLICATION_JSON)]
    [Consumes(TMediaType.APPLICATION_JSON)]
    function CreateTodo([BodyParam] todo: TTodo): TResponse;


    [GET, Path('/person')]
    [Produces(TMediaType.APPLICATION_JSON)]
    function GetPerson([QueryParam] id: Integer): TTodo; overload;

    [GET, Path('/persons')]
    [Produces(TMediaType.APPLICATION_JSON)]
    function GetPerson([QueryParam] id: Integer; [QueryParam]name: String): TTodo; overload;


    [GET, Path('/exception')]
    [Produces(TMediaType.APPLICATION_JSON)]
    function GetException: TTodo; overload;

  end;


implementation

function TTodoResource.GetTodo([PathParam] id: Integer; [PathParam] name: String): TTodo;
begin
  Result := TTodo.Create;
     Result.id := id;
     Result.title := name;
     Result.userId := 1;
     Result.completed := false;
end;

function TTodoResource.GetTodo([PathParam] id: Integer): TTodo;
begin
     Result := TTodo.Create;
     Result.id := 1;
     Result.title := 'Test TODO';
     Result.userId := 1;
     Result.completed := false;
end;

function TTodoResource.GetPerson([QueryParam] id: Integer): TTodo;
begin
     Result := TTodo.Create;
     Result.id := id;
     Result.title := 'Test TODO';
     Result.userId := 1;
     Result.completed := false;
end;

function TTodoResource.GetPerson([QueryParam] id: Integer; [QueryParam] name: String): TTodo;
begin
     Result := TTodo.Create;
     Result.id := id;
     Result.title := name;
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


function TTodoResource.GetException: TTodo;
begin
  Result := TTodo.Create;
  raise EWiRLNotImplementedException.Create('My Message', 'TTodoResource', 'GetException');
end;


initialization
  TWiRLResourceRegistry.Instance.RegisterResource<TTodoResource>;
end.
