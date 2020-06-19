unit RestClient.Core.RestCaller;

interface

uses
  System.Classes,
  System.SysUtils,
  WiRL.Core.JSON,
  RTTI,
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
  System.Generics.Collections;

type

TRestType = (GET, POST, PUT, DELETE);

TNeonConfig = class
  public
    class function BuildSerializerConfig: INeonConfiguration; virtual;
  end;

TUTF8EncodingNoBOM = class(TUTF8Encoding)
  public
    function GetPreamble: TBytes; override;
  end;

TRestCaller = class(TDataModule)
  private
    WiRLClient: TWiRLClient;
    WiRLApplication: TWiRLClientApplication;
    ServerURL: STring;
    Headers: TDictionary<String, String>;

    procedure DataModuleDestroy(Sender: TObject);
    function DoBuildSerializerConfig: INeonConfiguration;
    procedure ObjectToJSON(AContent: TMemoryStream; AObject: TObject);
    function BodyParam(AParam: TObject): TProc<TMemoryStream>;

  public
    constructor Create(AOwner: TComponent); override;
    //constructor  Create( const ServerURL : String);
    procedure SetServerURL(const AServerURL: String);
    procedure AddHeader(const key, value: String);
    function DoRestCall(const ARescource: String; const AType: TRestType; AResultType: TRttiType): TObject; overload;
    function DoRestCall(const ARescource: String; const AType: TRestType; AResultType: TRttiType; ABodyParam: TObject): TObject; overload;
  end;

implementation

uses
  System.TypInfo,
  Neon.Core.Serializers.RTL;

procedure TRestCaller.SetServerURL(const AServerURL: String);
begin
  ServerURL := AServerURL;
  WiRLClient.WiRLEngineURL := ServerURL;
end;

procedure TRestCaller.AddHeader(const key, value: String);
begin
  Headers.Add(key, value);
end;

class function TNeonConfig.BuildSerializerConfig: INeonConfiguration;
var
  neonVis: TNeonVisibility;
  neonMembers: TNeonMembersSet;
begin
  Result := TNeonConfiguration.Default;

  // Case settings
  Result.SetMemberCustomCase(nil);
  neonMembers := [TNeonMembers.Standard,TNeonMembers.Fields,TNeonMembers.Properties];
  Result.SetMembers(neonMembers);

  // Set Wirl server
  Result.SetMemberCase(TNeonCase.SnakeCase);
  Result.SetUseUTCDate(True);

  // F Prefix setting
  Result.SetIgnoreFieldPrefix(True);

  neonVis := [mvPublic,mvPublished];
  Result.SetVisibility(neonVis);

  Result.GetSerializers.RegisterSerializer(TGUIDSerializer);
end;

function TUTF8EncodingNoBOM.GetPreamble: TBytes;
begin
  Result := nil;
end;


function TRestCaller.DoRestCall(const ARescource: String; const AType: TRestType; AResultType: TRttiType): TObject;
var
  headerItem: TPair<String, String>;
  resResourceJSON: TWiRLClientResourceJSON;
begin
  try
    resResourceJSON := TWiRLClientResourceJSON.Create(Self);
    try
      resResourceJSON.Application := WiRLApplication;
      resResourceJSON.Resource := ARescource;

      // add headers if exists
      if (Headers <> nil) and (Headers.Count > 0) then
        for headerItem in Headers do
          resResourceJSON.Client.Request.HeaderFields.Add(headerItem.Key + ': ' +   headerItem.Value);

      if (AType = TRestType.GET) then
        resResourceJSON.GET()
      else if (AType = TRestType.POST) then
         resResourceJSON.POST()
      else if (AType = TRestType.PUT) then
        resResourceJSON.PUT()
      else if (AType = TRestType.DELETE) then
        resResourceJSON.DELETE();

      //Writeln(resResourceJSON.ResponseAsString);

      try
        Result := TNeon.JSONToObject(AResultType, resResourceJSON.Response,DoBuildSerializerConfig);
      except  on E: Exception do
          Writeln(E.Message);
      end;
    finally
      // clean headers
      resResourceJSON.Client.Request.HeaderFields.Clear;

      // TODO freeandnil
      resResourceJSON.DisposeOf;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt('RESTRequest execution failed with code %s', [E.Message]);
  end;
end;


// TODO imple body param only done for post method for test reasons
function TRestCaller.DoRestCall(const ARescource: String; const AType: TRestType; AResultType: TRttiType; ABodyParam: TObject): TObject;
var
  resResourceJSON: TWiRLClientResourceJSON;
begin
  try
    resResourceJSON := TWiRLClientResourceJSON.Create(Self);
    try
      resResourceJSON.Application := WiRLApplication;
      resResourceJSON.Resource := ARescource;

      if (AType = TRestType.GET) then
        resResourceJSON.GET()  // TODO make exception not possible to pass bodyparam
      else if (AType = TRestType.POST) then
         resResourceJSON.POST(BodyParam(ABodyParam))
      else if (AType = TRestType.PUT) then
        resResourceJSON.PUT(BodyParam(ABodyParam))
      else if (AType = TRestType.DELETE) then
       // raise EBodyParamNotAllowed.Create('Not allowed to use BodyParams with a DELETE request');
        resResourceJSON.DELETE(); // TODO make exception not possible to pass bodyparam

      //Writeln(resResourceJSON.ResponseAsString);

      try
        Result := TNeon.JSONToObject(AResultType, resResourceJSON.Response,DoBuildSerializerConfig);
      except  on E: Exception do
          Writeln(E.Message);
      end;
    finally
      // TODO freeandnil
      resResourceJSON.DisposeOf;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt('RESTRequest execution failed with code %s', [E.Message]);
  end;
end;

constructor TRestCaller.Create(AOwner: TComponent);
begin
  Headers := TDictionary<String,String>.Create;

  WiRLClient := TWiRLClient.Create(Self);
  WiRLClient.WiRLEngineURL := ServerURL;
  WiRLClient.ConnectTimeout := 3000;

  WiRLApplication := TWiRLClientApplication.Create(Self);
  WiRLApplication.Client := WiRLClient;
  WiRLApplication.DefaultMediaType := 'application/json;';    // TODO create Attribute
  WiRLApplication.AppName := '';
end;

procedure TRestCaller.DataModuleDestroy(Sender: TObject);
begin
  WiRLApplication.DisposeOf;
  WiRLClient.DisposeOf;
  Headers.DisposeOf;
end;

function TRestCaller.DoBuildSerializerConfig: INeonConfiguration;
begin
  Result := TNeonConfig.BuildSerializerConfig;
end;

procedure TRestCaller.ObjectToJSON(AContent: TMemoryStream; AObject: TObject);
var
  content: TStringList;
  UTF8EncodingNoBOM: TUTF8EncodingNoBOM;
begin
  content := TStringList.Create;
  UTF8EncodingNoBOM := TUTF8EncodingNoBOM.Create;
  try
    content.Text := TNeon.ObjectToJSONString(AObject, DoBuildSerializerConfig);
    content.SaveToStream(AContent, UTF8EncodingNoBOM);

    AContent.Position := 0;
  finally
    UTF8EncodingNoBOM.DisposeOf;
    content.DisposeOf;
  end;
end;

function TRestCaller.BodyParam(AParam: TObject): TProc<TMemoryStream>;
begin
  Result :=
    procedure(AContent: TMemoryStream)
    begin
      ObjectToJSON(AContent, AParam);
    end
end;

end.
