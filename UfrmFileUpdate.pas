unit UfrmFileUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, sEdit, Buttons, sBitBtn, sLabel, sSkinManager,
  ExtCtrls, sBevel, ComCtrls, sStatusBar, acPNG, acImage;

type
  TfrmFileUpdate = class(TForm)
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Edit2: TMaskEdit;
    Button3: TButton;
    sSkinManager1: TsSkinManager;
    sLabelFX1: TsLabelFX;
    sBitBtn1: TsBitBtn;
    sEdit1: TsEdit;
    sBevel1: TsBevel;
    sStatusBar1: TsStatusBar;
    sLabelFX2: TsLabelFX;
    sImage1: TsImage;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    function SetFileDateTime(FileName: string; CreateTime, ModifyTime, AcessTime: TDateTime): Boolean;
  public
    { Public declarations }
  end;

var
  frmFileUpdate: TfrmFileUpdate;

implementation

{$R *.dfm}

procedure TfrmFileUpdate.Button2Click(Sender: TObject);
var 
  HFile: Word; 
  MyDate: TDateTime; 
  MyDate2: Integer;
begin
  try
     HFile:= FileOpen(sEdit1.Text, fmOpenWrite);
     MyDate:= StrToDateTime(Edit2.Text);
     MyDate2:= DateTimeToFileDate(MyDate);
     FileSetDate(HFile, MyDate2);
     FileClose(HFile);
     MessageDlg('Arquivo alterado com Sucesso!!!', mtInformation, [mbok], 0);
  except
     MessageDlg('Não foi possivel alterar a data do Arquivo!', mtWarning, [mbok], 0);
  end;
end;

procedure TfrmFileUpdate.Button3Click(Sender: TObject);
var
  MyDate: TDateTime;
begin
  try
    MyDate:= StrToDateTime(Edit2.Text);
    SetFileDateTime(sEdit1.Text, MyDate, MyDate, MyDate);
    MessageDlg('Arquivo alterado com Sucesso!!!', mtInformation, [mbok], 0);
  except
    MessageDlg('Não foi possivel alterar a data do Arquivo!', mtWarning, [mbok], 0);
  end;
end;

function TfrmFileUpdate.SetFileDateTime(FileName: string; CreateTime, ModifyTime, AcessTime: TDateTime): Boolean;

  function ConvertToFileTime(DateTime :TDateTime) :PFileTime;
  var
    FileTime: TFileTime;
    LFT: TFileTime;
    LST: TSystemTime;
  begin
    Result := nil;
    if DateTime > 0 then
      begin
      DecodeDate(DateTime, LST.wYear, LST.wMonth, LST.wDay);
      DecodeTime(DateTime, LST.wHour, LST.wMinute, LST.wSecond, LST.wMilliSeconds);
      if SystemTimeToFileTime(LST, LFT) then
        if LocalFileTimeToFileTime(LFT, FileTime) then
          begin
          New(Result);
          Result^ := FileTime;
          end;
      end;
  end;                                             

var
  FileHandle: Integer;
  ftCreateTime,
  ftModifyTime,
  ftAcessTime: PFileTime;
begin
  Result := False;
  try
    ftCreateTime := ConvertToFileTime(CreateTime);
    ftModifyTime := ConvertToFileTime(ModifyTime);
    ftAcessTime  := ConvertToFileTime(AcessTime);
    try
      FileHandle := FileOpen(FileName, fmOpenReadWrite or fmShareExclusive);
      Result := SetFileTime(FileHandle, ftCreateTime, ftAcessTime, ftModifyTime);
    finally
      FileClose(FileHandle);
    end;
  finally
    Dispose(ftCreateTime);
    Dispose(ftAcessTime);
    Dispose(ftModifyTime);
  end;
end;

procedure TfrmFileUpdate.sBitBtn1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    sEdit1.Text := OpenDialog1.FileName;
end;

end.
