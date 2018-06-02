unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ShowFrame, Data.DB,
  Data.SqlExpr, Data.DbxSqlite, System.Generics.Collections, CShow, CGuest, CSeat, CRender;

type
  TForm1 = class(TForm)
    mainConnection: TSQLConnection;
    Frame11: TFrame1;
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    render : TRender;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);

var shows   : TObjectList<TShow>;
var guests  : TObjectList<TGuest>;
var show : TShow;
var guest : array[0..20] of TGuest;
var i : Integer;
var seat : array[0..50] of TSeat;

begin

  //Connect to database

  mainConnection.Params.Add('Database=main.db');

  try
    
    //Connection established
    mainConnection.Connected := true;

    //Get the shows

  //Create shows

    show := TShow.create('Happy Days');

    //Add seats to show

    for i := 0 to 49 do
    begin
      seat[i] := TSeat.create(0, i);
      show.add_seat(seat[i]);
    end;

    //Add guests to show
    for i := 0 to 9 do
    begin
      guest[i] := TGuest.create('blah', i);

      guest[i].set_seat(seat[i]);
      show.add_guest(guest[i]);
    end;

  //Render show
  self.render := TRender.create(self.Frame11, show);

  self.render.draw();

  except
    on E: EDatabaseError do
    begin
      ShowMessage('Couldn''t connect to database: ' + E.Message);
    end;
  end;


end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

  //Call destructor to free memory
  self.render.destroy();

end;

procedure TForm1.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  showmessage('TEST');
end;

end.