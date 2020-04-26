program Test;
{
  This is a simple example on how to use custom attributes.
  The class uses a custom attribute to retrieve a static date
  at program start-up. This is just for the purpose of demo.
  This demo's:
  - Creation
  - Decoration
  - Retrieval
}

{$mode delphi}{$H+}{$M+}
{$warn 5079 off} { turn warning experimental off }
uses
  sysutils, typinfo, rtti, classes;

type
   {A custom attribute to decorate a class with a certain date }
   ADateTimeAttribute = class(TCustomAttribute)
   private
     FArg:TDateTime;
   public
   { Just to show a Custom Attribute can have mutiple constructors }
     constructor Create(const aArg: TDateTime);overload;
     { We can use the predefined %DATE% compiler include
       In the context of a custom attribute we need a
       constant expression for the default parameter }
     constructor Create(const aArg: String = {$I %DATE%});overload;
    published
     property Date:TDateTime read Farg;
   end;

   { A datetime class that is decorated with our custom attribute     }
   { Note you can leave out 'Attribute', the compiler resolves it     }
   { [ADateTime(21237.0)] uses first constructor,displays some date in 1958 }

   {This calls the second constructor }
   [ADateTime]
   TMyDateTimeClass = class
   private
     FDateTime:TDateTime;
   public
     constructor create;
   published
     [ADateTime]
     property Day:TDateTime read FDatetime write FdateTime;
   end;

   constructor ADateTimeAttribute.Create(const aArg: TDateTime);
   begin
     FArg := aArg;
   end;

   constructor ADateTimeAttribute.Create(const aArg: string );
   var
     MySettings:Tformatsettings;
   begin
     { set up the date format according to how
       the compiler formats %DATE% include }
     MySettings :=DefaultFormatSettings;
     MySettings.ShortDateFormat:='yyyymmdd';
     MySettings.DateSeparator :='/';
     { Now convert }
     FArg := StrToDateTime(aArg, MySettings);
   end;

   { We query the rtti to set the value }
   constructor TMyDateTimeClass.Create;
   var
    Context : TRttiContext;
    AType : TRttiType;
    Attribute : TCustomAttribute;
   begin
     inherited;
     Context := TRttiContext.Create;
     try
       AType := Context.GetType(typeinfo(TMyDateTimeClass));
       for Attribute in  AType.GetAttributes do begin
         if Attribute is ADateTimeAttribute then
           FDateTime := ADateTimeAttribute(Attribute).Date;
       end;
     finally
       Context.Free
     end;
   end;


var
 Test:TMyDateTimeClass;
begin
   Test := TMyDateTimeClass.Create;
   try
     writeln('Compile date is :',DateTimeToStr(Test.Day));
  finally
    test.free;
  end;
end.
