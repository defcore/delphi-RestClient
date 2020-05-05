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
  TRestClient = class
  private
    constructor Create();
    destructor Destroy;
  public
    procedure RegisterClient<T,S>;
    function Resolve<T>: T;
  end;

   RestClient<API:IInterface> = record
    public class function Resolve: API; static; inline;
  end;

  RestClient2 = record
    public class function Resolve<API:IInterface>: API; static; inline;
  end;

var
  GlobalRestClient: TRestClient;

implementation


class function RestClient<API>.Resolve: API;
begin
  Result := TProxyGenerator.CreateInterfaceProxyWithoutTarget<API>(TRestClientInterceptor.Create());
end;


class function RestClient2.Resolve<API>: API;
begin
  Result := TProxyGenerator.CreateInterfaceProxyWithoutTarget<API>(TRestClientInterceptor.Create());
end;

// TODO find better place todo call Build
constructor TRestClient.Create;
begin
  GlobalContainer.RegisterType<IInterceptor, TRestClientInterceptor>('client');
  GlobalContainer.Build;
end;

destructor TRestClient.Destroy;
begin
   //FreeAndNil(GlobalContainer);
end;

procedure TRestClient.RegisterClient<T, S>;
begin
  GlobalContainer.RegisterType<T,S>;
  GlobalContainer.Build;
end;

function TRestClient.Resolve<T>: T;
begin
  Result := GlobalContainer.Resolve<T>
end;

initialization
  GlobalRestClient := TRestClient.Create;
end.
