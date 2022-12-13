unit uMain;

interface

uses
  System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, uMainController,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFormMain = class(TForm)
    lblMsg: TLabel;
    lblLimitat: TLabel;
    edtLimitat: TEdit;
    Panel1: TPanel;
    btnRun: TButton;
    btnCancel: TButton;
    ProgressBar: TProgressBar;
    procedure FormDestroy(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FController: TMainController;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  System.SysUtils;

procedure TFormMain.btnCancelClick(Sender: TObject);
begin
  FController.Cancel;
end;

procedure TFormMain.btnRunClick(Sender: TObject);
var
  vLimitat: integer;
begin
  if not TryStrToInt(edtLimitat.Text, vLimitat) then
    lblMsg.Caption := 'В поле "Ограничение" должны быть только цифры'
  else
  begin
    FController.Limitat := vLimitat;
    FController.Run;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FController := TMainController.Create;
  FController.OnNext :=
    procedure(pMax, pNumber: integer)
    begin
      ProgressBar.Max := pMax;
      ProgressBar.Position := pNumber;
    end;

  FController.OnMaxReached :=
    procedure(pMax, pNumber: integer)
    begin
      ProgressBar.Position := 0;

      lblMsg.Caption :=
        Format('Получено максимальное натуральное число %d в интервале 0-%d',
          [pNumber, pMax]);
    end;

  FController.OnBeforeRun :=
    procedure
    begin
      lblMsg.Caption := EmptyStr;

      btnRun.Enabled := False;
      btnCancel.Enabled := True;

      Screen.Cursor := crHourGlass;
    end;

  FController.OnAfterCancel :=
    procedure
    begin
      btnRun.Enabled := True;
      btnCancel.Enabled := False;

      Screen.Cursor := crDefault;
    end;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FController) then
    FreeAndNil(FController)
end;

end.
