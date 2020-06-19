unit RestClient.Core;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.TypInfo,
  Spring,
  Spring.Container,
  Spring.Container.Common,
  Spring.Interception,
  RestClient.Core.Interceptor;

type
  TRestClient = class
    public
      function Resolve<API:IInterface>: API; overload;
      function Resolve<API:IInterface>(const ABasePath: String): API; overload;
      function Resolve<API:IInterface>(const ABasePath: String; const AAuthToken: String): API; overload;
  end;

var
  GlobalRestClient : TRestClient;

implementation

function TRestClient.Resolve<API>: API;
begin
  Result := TProxyGenerator.CreateInterfaceProxyWithoutTarget<API>(TRestClientInterceptor.Create(''));
end;

function TRestClient.Resolve<API>(const ABasePath: String): API;
begin
  Result := TProxyGenerator.CreateInterfaceProxyWithoutTarget<API>(TRestClientInterceptor.Create(ABasePath));
end;

function TRestClient.Resolve<API>(const ABasePath: String; const AAuthToken: String): API;
begin
  Result := TProxyGenerator.CreateInterfaceProxyWithoutTarget<API>(TRestClientInterceptor.Create(ABasePath, AAuthToken));
end;

initialization
  GlobalRestClient := TRestClient.Create;
finalization
  FreeAndNil(GlobalRestClient);

end.
