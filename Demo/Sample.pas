unit Sample;

interface

uses
  Attributes,
  System.Generics.Collections,
  Neon.Core.Attributes,
  Spring.Container.Common;

type

TResponse = class
  private
    FResult: Boolean;
  public
    property Result: Boolean read FResult write FResult;
end;

TTodo = class
  private
    FUserId: Integer;
    FId: Integer;
    FTitle: String;
    FCompleted: boolean;
  public
    [NeonIgnore]
    property userId: Integer read FUserId write FUserId;
    property id: Integer read FId write FId;
    property title: String read FTitle write FTitle;
    property completed: boolean read FCompleted write FCompleted;
end;

[PATH('http://localhost:8080/rest/app/v1')]
ISampleRestClient = interface(IInvokable)
['{6D0F52B4-A96F-4C96-97A4-DE45324FDE1B}']

  [GET('/todos/{id}')]
  function GetTodo([PathParam]id: Integer): TTodo;

  [GET('/todos')]
  function GetTodos: TObjectList<TTodo>;

  [POST('/todos')]
  function CreateTodo([BodyParam] param: TTodo): TResponse;

end;


[Interceptor('client')]
TSampleRestClient = class(TInterfacedObject, ISampleRestClient)
public

  //[Header('X-MyCustomHeader')]
  //CustomHeader: String;

  function GetTodos: TObjectList<TTodo>;

  function GetTodo(id: Integer): TTodo;

  function CreateTodo(param: TTodo): TResponse;

end;



implementation

 function TSampleRestClient.GetTodo(id: Integer): TTodo;
 begin
    // NO implementations needed
 end;

 function TSampleRestClient.GetTodos: TObjectList<TTodo>;
 begin
    // NO implementations needed
 end;

 function TSampleRestClient.CreateTodo(param: TTodo): TResponse;
 begin
    // NO implementations needed
 end;


end.

