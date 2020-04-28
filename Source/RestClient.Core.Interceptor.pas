unit RestClient.Core.Interceptor;

interface

uses
  Spring.Interception,
  Spring.Reflection,
  System.Rtti,
  RestClient.Core.RestCaller,
  Sample,
  RestClient.Core.Attributes;

type

TRestClientInterceptor = class(TInterfacedObject, IInterceptor)
  public
    procedure Intercept(const invocation: IInvocation);
  end;

implementation

uses
  SysUtils;


procedure TRestClientInterceptor.Intercept(const invocation: IInvocation);
var
  restCaller: TRestCaller;
  getAttribute: GET;
  postAttribute: POST;
  putAttribute: PUT;
  deleteAttribute: DELETE;

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
begin
  //Writeln('Before ', invocation.Method.Parent.Name, '.', invocation.Method.Name, '....');
  bodyParam := nil;

  pathAttribute := invocation.Method.Parent.GetCustomAttribute<PATH>;
  if pathAttribute <> nil then begin
    restCaller := TRestCaller.Create(nil);
    restCaller.SetServerURL(pathAttribute.Path);

    // Set endpoint and request type
    getAttribute := invocation.Method.GetCustomAttribute<GET>;
    if (getAttribute <> nil) then begin
      endpoint := getAttribute.Path;
      restType := TRestType.GET;
    end;

    postAttribute := invocation.Method.GetCustomAttribute<POST>;
    if (postAttribute <> nil) then begin
      endpoint := postAttribute.Path;
      restType := TRestType.POST;
    end;

    putAttribute := invocation.Method.GetCustomAttribute<PUT>;
    if (putAttribute <> nil) then begin
      endpoint := putAttribute.Path;
      restType := TRestType.PUT;
    end;

    deleteAttribute := invocation.Method.GetCustomAttribute<DELETE>;
    if (deleteAttribute <> nil) then begin
      endpoint := deleteAttribute.Path;
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

         { case value.TypeInfo.Name of
            'Integer' : endpoint := StringReplace(endpoint, tmpReplaceString, IntToStr(value.AsInteger), [rfReplaceAll, rfIgnoreCase]);
            'Int64'   : endpoint := StringReplace(endpoint, tmpReplaceString, IntToStr(value), [rfReplaceAll, rfIgnoreCase]);
          end;
          }



          //Writeln('path ' + endpoint) ;
        end
        else if (a.ClassNameIs('BodyParam')) then begin
          if (value.IsObject) then
            bodyParam := value.AsObject;
          // TODO else make exception has always to be a object
        end;


      end;
      i := i + 1;
    end;

    // proceed function call
    invocation.Proceed;

    // Do rest call
    if (bodyParam = nil) then
      invocation.Result := restCaller.DoRestCall(endpoint, restType, invocation.Method.ReturnType)
    else
      invocation.Result := restCaller.DoRestCall(endpoint, restType, invocation.Method.ReturnType, bodyParam);
  end;


  FreeAndNil( restCaller);



   {

  // TODO remove onyly for testing reasons

  // get class Attributes
  for pathAttribute in invocation.Method.Parent.GetCustomAttributes<PATH> do begin
    Writeln(pathAttribute.path);
  end;

  // get parameter value
  for value in invocation.Arguments do begin
    if value.IsType<Integer> then
      Writeln(value.AsInteger)
    else if value.IsType<String> then
       Writeln(value.AsString)
    else if value.IsType<TObject> then
      Writeln(value.AsObject.ClassName);
  end;


  // get parameter attributes
//  for p in invocation.Method.GetParameters do
//    for a in p.GetAttributes do
//      Writeln('Attribute "', a.ClassName, '" found on parameter "', p.Name, '"');

  // get return type
  invocation.Result;


  // get method attributes
  for getAttribute in invocation.Method.GetCustomAttributes<GET> do begin
    Writeln(getAttribute.path);
  end;

  for postAttribute in invocation.Method.GetCustomAttributes<POST> do begin
    Writeln(postAttribute.path);
  end;

  invocation.Method.Parent ;

  // set header global variable
  //for field in invocation.Method.Parent.GetFields do begin
  //  if field.HasCustomAttribute(Header) then begin
  //    headerAttr := field.GetCustomAttribute<Header>;
  //    Writeln(headerAttr.Name);
  //  end;
  //end;




  // proceed function call
//  invocation.Proceed;
  Writeln('After ', invocation.Method.Name, '....');
  }
end;



end.

