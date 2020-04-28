program PerformanceTests;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Classes,
  System.Diagnostics,
  Neon.Core.Types,
  Neon.Core.Persistence.JSON,
  Neon.Core.Attributes,
  Neon.Core.Persistence,
  WiRL.Client.Application,
  WiRL.http.Client.NetHttp,
  WiRL.http.Client,
  WiRL.Client.CustomResource,
  WiRL.Client.Resource,
  WiRL.Client.Resource.JSON,
  Sample in 'Demo\Sample.pas',
  Server.Recources.Todos in 'Demo\Server.Recources.Todos.pas',
  RestClient.Core.Attributes in 'Source\RestClient.Core.Attributes.pas',
  RestClient.Core.Interceptor in 'Source\RestClient.Core.Interceptor.pas',
  RestClient.Core.RestCaller in 'Source\RestClient.Core.RestCaller.pas',
  RestClient.Core in 'Source\RestClient.Core.pas';

var
  I: Integer;
  numberOfExecutions: Integer;
  sampleRestClient: ISampleRestClient;
  todo: TTodo;
  restCaller: TRestCaller;
  sw: TStopwatch;
  sw2: TStopwatch;
begin
  try
    //My Method


    numberOfExecutions := 10000;
    Writeln('Number of iterations: ' + IntToStr(numberOfExecutions));



    sw := TStopwatch.StartNew;

    GlobalRestClient.RegisterClient<ISampleRestClient, TSampleRestClient>;
    sampleRestClient := GlobalRestClient.Resolve<ISampleRestClient>;

    for I := 0 to numberOfExecutions do begin
      todo := sampleRestClient.GetTodo(1);
    end;

    sw.Stop;
    Writeln('My RestClient GET: ', sw.ElapsedMilliseconds / numberOfExecutions, ' ms');


    // Standard Method
    sw2 := TStopwatch.StartNew;

    for I := 0 to numberOfExecutions do begin
      restCaller := TRestCaller.Create(nil);
      restCaller.SetServerURL('http://localhost:8080/rest/app/v1');
      todo :=  restCaller.DoStandardRestCall('/todos/1', TRestType.GET);
    end;

    sw2.Stop;


    FreeAndNil(restCaller);
    FreeAndNil(todo);


    //Writeln('My RestClient GET: ', sw.ElapsedMilliseconds / numberOfExecutions, ' ms');
    Writeln('Wirl RestClient GET: ', sw2.ElapsedMilliseconds / numberOfExecutions, ' ms');

   // Writeln('Difference: ', (sw.ElapsedMilliseconds / numberOfExecutions) - (sw2.ElapsedMilliseconds / numberOfExecutions) , ' ms' );
    Readln;


  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
