unit RestClient.Core;

interface

uses
  System.SysUtils,
  Spring,
  Spring.Container,
  Spring.Container.Common,
  Spring.Interception,
  Interceptors;

type
  TRestClient = class
  private
    constructor Create();
    destructor Destroy;
  public
    procedure RegisterClient<T,S>;
    function Resolve<T>: T;
  end;

var
  GlobalRestClient: TRestClient;

implementation



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
