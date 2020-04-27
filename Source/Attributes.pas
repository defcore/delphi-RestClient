unit Attributes;


interface

type

{$SCOPEDENUMS ON}

TBaseRequest = class(TCustomAttribute)
   private
    FPath: String;
  public
    constructor Create(const APath: String);
    property Path: String read FPath write FPath;
end;

PATH = class(TBaseRequest);

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

BodyParam = class(TBaseParam);

implementation

constructor TBaseRequest.Create(const APath: String);
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
