# delphi-RestClient

RestClient helps to speedup implementation of delphi clients for rest endpoints by providing some custom attributes. This helps to write less code and therefor make less errors.

This library makes use of following libraries:
[WiRL](https://github.com/delphi-blocks/WiRL)
[Spring4D](https://bitbucket.org/sglienke/spring4d/src)

## Usage


Client endpoint definition:
```pascal
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
```

Client initialisation and call:

```pascal
// init Client
GlobalRestClient.RegisterClient<ISampleRestClient, TSampleRestClient>;

// get Client Object
sampleRestClient := GlobalRestClient.Resolve<ISampleRestClient>;

// do Rest call
todo := sampleRestClient.GetTodo(1);
```


## TODO

* Add possibility to pass some custom headers on functions or classes ```[Header('X-Name', 'Alex')]``` also give posibillity to pass them in a more dynamic way as a Param ```[Header('X-Name')] AHeaderName: String```
* Add HTTP status code results ```[StatusCode] AStatusCode: Integer``` or even better use exceptions instead
* Add custom exceptions
* Add posibillity to pas a custom NeonConfiguration
* Add possibility to set custom serializers
* Add some default serializers for some common used objects


## More advanced TODOs 

* Add local cache ```[Cache( TIME )]``` to keep results of the rest calls somewehere (memory or local db) for the period of TIME. 

