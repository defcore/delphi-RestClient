unit RestClient.Core.Exceptions;

interface

uses
  System.SysUtils;

type

EBaseRestClientException = class(Exception);

EBodyParamNotAllowed = class(EBaseRestClientException);

implementation

end.
