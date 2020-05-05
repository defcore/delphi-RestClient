unit Sample.Classes;

interface
type
TResponse = class
  private
    FResult: Boolean;
  public
    property Result: Boolean read FResult write FResult;
end;

TTodo = class
  private
    FUserId: Integer;
    FId: Integer;
    FTitle: String;
    FCompleted: boolean;
  public
    [NeonIgnore]
    property userId: Integer read FUserId write FUserId;
    property id: Integer read FId write FId;
    property title: String read FTitle write FTitle;
    property completed: boolean read FCompleted write FCompleted;
end;

implementation

end.
