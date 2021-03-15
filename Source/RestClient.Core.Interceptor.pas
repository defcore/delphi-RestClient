unit RestClient.Core.Interceptor;

interface

uses
  Spring.Interception,
  Neon.Core.Types;

type

TRestClientInterceptor = class(TInterfacedObject, IInterceptor)
  private
    FBasePath: String;
    FAuthToken: String;
    FNeonCase: TNeonCase;
  public
    constructor Create(const ABasePath: String); overload;
    constructor Create(const ABasePath: String; const AAuthToken: String); overload;
    constructor Create(const ABasePath: String; const ANeonCase: TNeonCase); overload;
    procedure Intercept(const invocation: IInvocation);
  end;

implementation

uses
  SysUtils,
  Spring.Reflection,
  System.Rtti,
  RestClient.Core.RestCaller,
  RestClient.Core.Attributes;

constructor TRestClientInterceptor.Create(const ABasePath: String);
begin
  FBasePath := ABasePath;
  FAuthToken := '';
end;

constructor TRestClientInterceptor.Create(const ABasePath: String; const AAuthToken: String);
begin
  FBasePath := ABasePath;
  FAuthToken := AAuthToken
end;

constructor TRestClientInterceptor.Create(const ABasePath: String; const ANeonCase: TNeonCase);
begin
  FBasePath := ABasePath;
  FNeonCase := ANeonCase;
end;

procedure TRestClientInterceptor.Intercept(const invocation: IInvocation);
var
  restCaller: TRestCaller;
  getAttribute: GET;
  postAttribute: POST;
  putAttribute: PUT;
  deleteAttribute: DELETE;
  pathMethodAttribute: Path;

  // at the moment only one bodyparam can be added to a function
  bodyParam : TObject;

  baseRequestAttribute : TBaseRequest;
  pathAttribute: PATH;
  value: TValue;
  p: TRttiParameter;
  a: TBaseParam;
  field : TRttiField;
  headerAttr : Header;
  endpoint: String;
  restType : TRestType;
  tmpReplaceString : String;
  arguments : TArray<TValue>;
  i : Integer;
  url: String;
begin
  //Writeln('Before ', invocation.Method.Parent.Name, '.', invocation.Method.Name, '....');
  bodyParam := nil;

  // get base path of class
  pathAttribute := invocation.Method.Parent.GetCustomAttribute<PATH>;
  //if pathAttribute <> nil then begin
  restCaller := TRestCaller.Create(nil);

  // set url
  if (FBasePath <> '') then begin
    if pathAttribute <> nil then
      url := FBasePath + pathAttribute.Path
    else
      url := FBasePath;
  end
  else
    url := pathAttribute.Path;
  restCaller.SetServerURL(url);

  // add headers
  if (FAuthToken <> '') then
    restCaller.AddHeader('Authorization', FAuthToken);

  pathMethodAttribute := invocation.Method.GetCustomAttribute<Path>;
  if (pathMethodAttribute <> nil) then begin
    endpoint := pathMethodAttribute.Path;
  end;

  // Set endpoint and request type
  getAttribute := invocation.Method.GetCustomAttribute<GET>;
  if (getAttribute <> nil) then begin
    restType := TRestType.GET;
  end;

  postAttribute := invocation.Method.GetCustomAttribute<POST>;
  if (postAttribute <> nil) then begin
    restType := TRestType.POST;
  end;

  putAttribute := invocation.Method.GetCustomAttribute<PUT>;
  if (putAttribute <> nil) then begin
    restType := TRestType.PUT;
  end;

  deleteAttribute := invocation.Method.GetCustomAttribute<DELETE>;
  if (deleteAttribute <> nil) then begin
    restType := TRestType.DELETE;
  end;

  // get PathParams and produce endpoint
  i := 0;
  arguments := invocation.Arguments;
  for p in invocation.Method.GetParameters do begin
    for a in p.GetCustomAttributes<TBaseParam> do begin
      value := arguments[i];

      if (a.ClassNameIs(PathParam.ClassName)) then begin
        //writeln(value.TypeInfo.Name);

        tmpReplaceString := '{'+ p.Name+'}';
        endpoint := StringReplace(endpoint, tmpReplaceString, value.ToString, [rfReplaceAll, rfIgnoreCase]);

        //Writeln('path ' + endpoint) ;
      end
      else if (a.ClassNameIs('QueryParam')) then begin
        if (endpoint.Contains('?')) then
          endpoint := endpoint + '&' + p.Name + '=' + value.ToString
        else
          endpoint := endpoint + '?' + p.Name + '=' + value.ToString;
      end
      else if (a.ClassNameIs('BodyParam')) then begin
        if (value.IsObject) then
          bodyParam := value.AsObject;
        // TODO else make exception has always to be a object
      end;


    end;
    i := i + 1;
  end;

  // proceed function call not allowed with proxy
  //invocation.Proceed;

  restCaller.SetNeonCase(FNeonCase);

  // Do rest call
  if (bodyParam = nil) then
    invocation.Result := restCaller.DoRestCall(endpoint, restType, invocation.Method.ReturnType)
  else
    invocation.Result := restCaller.DoRestCall(endpoint, restType, invocation.Method.ReturnType, bodyParam);
  //end;


  FreeAndNil( restCaller);
end;



end.

