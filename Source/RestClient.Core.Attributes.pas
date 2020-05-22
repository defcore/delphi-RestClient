unit RestClient.Core.Attributes;


interface

type

{$SCOPEDENUMS ON}

TBasePath = class(TCustomAttribute)
   private
    FPath: String;
  public
    constructor Create(const APath: String);
    property Path: String read FPath write FPath;
end;

PATH = class(TBasePath);


TBaseRequest = class(TCustomAttribute);

GET = class(TBaseRequest);

POST = class(TBaseRequest);

PUT = class(TBaseRequest);

DELETE = class(TBaseRequest);


Header = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(const AName: String);
    property Name: String read FName write FName;
end;


TBaseParam = class(TCustomAttribute)

end;

PathParam = class(TBaseParam);

QueryParam = class(TBaseParam);

BodyParam = class(TBaseParam);

implementation

constructor TBasePath.Create(const APath: String);
begin
  inherited Create;
  FPath := APath;
end;

constructor Header.Create(const AName: String);
begin
  inherited Create;
  FName := AName;
end;


end.
