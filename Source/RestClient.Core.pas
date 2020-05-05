unit RestClient.Core;

interface

uses
  System.SysUtils,
  Spring,
  Spring.Container,
  Spring.Container.Common,
  Spring.Interception,
  RestClient.Core.Interceptor;

type
  TRestClient = record
    public class function Resolve<API:IInterface>: API; static; inline;
  end;

implementation
class function TRestClient.Resolve<API>: API;
begin
  Result := TProxyGenerator.CreateInterfaceProxyWithoutTarget<API>(TRestClientInterceptor.Create());
end;

end.
