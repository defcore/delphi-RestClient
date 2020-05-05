unit RestClient.Core.RestConnection;

interface

uses
  Spring,
  Spring.Container,
  Spring.Container.Common,
  Spring.Interception,
  System.Rtti,
  RestClient.Core.Interceptor;

type
  TRestConnection<API:IInterface> = record
    function Invoke: API;
  end;

  TRestClient<API:IInterface> = record
    public class function Call: TRestConnection<API>; static; inline;
  end;

implementation

class function TRestClient<API>.Call: TRestConnection<API>;
begin
  //Result := TRESTConnection<API>;
end;

function TRestConnection<API>.Invoke: API;
begin
   Result := TProxyGenerator.CreateInterfaceProxyWithoutTarget<API>(TRestClientInterceptor.Create());
end;

end.
