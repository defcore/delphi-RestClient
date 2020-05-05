unit SampleRestAPI;

interface

uses
  RestClient.Core.Attributes,
  System.Generics.Collections,
  Neon.Core.Attributes,
  Spring.Container.Common,
  Sample.Classes;

type


[PATH('http://localhost:8080/rest/app/v1')]
ISampleRestClient = interface(IInvokable)
 ['{54E1D5F5-EE4B-4F69-8025-55ED83960C0D}']

  [GET('/todos/{id}')]
  function GetTodo([PathParam]id: Integer): TTodo; overload;

  [GET('/todos/{id}/name/{name}')]
  function GetTodo([PathParam]id: Integer; [PathParam]name: String): TTodo; overload;

  [GET('/todos')]
  function GetTodos: TObjectList<TTodo>; overload;

  [POST('/todos')]
  function CreateTodo([BodyParam] param: TTodo): TResponse; overload;

  [GET('/person/')]
  function GetPerson([QueryParam] id: Integer): TTodo; overload;

  [GET('/person/')]
  function GetPerson([QueryParam] id: Integer;[QueryParam]name: String): TTodo; overload;

end;

implementation

end.

