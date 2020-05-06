unit RestClient.Core.Exceptions;

interface

uses
  System.SysUtils,
  System.JSON;

type

EBaseRestClientException = class(Exception);

EBodyParamNotAllowed = class(EBaseRestClientException);


EWiRLHttpStatusException = class
  private
  //{"status":501,"exception":"EWiRLNotImplementedException","message":"My Message","data":{"issuer":"TTodoResource","method":"GetException"}}
    FStatus : Integer;
    FException: String;
    FMessage: String;
    FData: TJSONObject;
  public
    property Status: Integer read FStatus write FStatus;
    property Exception: String read FException write FException;
    property Message: String read FMessage write FMessage;
    property Data: TJSONObject read FData write FData;
  end;

{
EWiRLNotFoundException = class(EWiRLHttpStatusException)
    public const FStatusCode = 404;
  end;

  [StatusCode(401)]
EWiRLNotAuthorizedException = class(EWiRLHttpStatusException)
  end;

  [StatusCode(406)]
  EWiRLNotAcceptableException = class(EWiRLHttpStatusException)
  end;

  [StatusCode(415)]
  EWiRLUnsupportedMediaTypeException = class(EWiRLHttpStatusException)
  end;

  // Server errors (500)

  [StatusCode(500)]
  EWiRLServerException = class(EWiRLHttpStatusException)
  end;

  EWiRLNotImplementedException = class(EWiRLHttpStatusException)
    public const FStatusCode = 501;
  end;
  }

implementation

end.
