unit weldSksStandard;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Buttons, Spin;

type

  { TSksStandard }

  TSksStandard = class(TFrame)
    btGenerar: TButton;
    ButtonCopiar: TButton;
    chkAdd: TCheckBox;
    chkFronius: TCheckBox;
    chkUseTask: TCheckBox;
    edPrefijoSoldadura: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Minimo: TLabel;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    spMaximo: TSpinEdit;
    spMinimo: TSpinEdit;
    procedure btGenerarClick(Sender: TObject);
    procedure ButtonCopiarClick(Sender: TObject);
    procedure edPrefijoSoldaduraChange(Sender: TObject);
  private
    procedure Validar;
    procedure Generar;
  public

  end;

implementation

uses main;
  {$R *.lfm}

  { TSksStandard }

procedure TSksStandard.btGenerarClick(Sender: TObject);
begin
  if btGenerar.Enabled then
    Generar;
end;

procedure TSksStandard.ButtonCopiarClick(Sender: TObject);
begin
  mainfrm.Copiar;
end;

procedure TSksStandard.edPrefijoSoldaduraChange(Sender: TObject);
begin
  Validar
end;

procedure TSksStandard.Validar;
begin
  btGenerar.Enabled := (edPrefijoSoldadura.Text <> '') and
    (spMinimo.Value < spMaximo.Value);
end;

procedure TSksStandard.Generar;
var
  Cadena: string;
  I: integer;
  programa, Cabecera: string;
  c, Modo: char;
begin
  if not chkAdd.Checked then
  begin
    MainFrm.mnDatos.Clear;
  end;

  programa := '';
  for I := 1 to Length(edPrefijoSoldadura.Text) do
  begin
    c := edPrefijoSoldadura.Text[I];
    if c in ['0'..'9'] then
    begin
      programa := programa + c;
    end;
  end;
  Modo := '0';
  if chkFronius.Checked then
  begin
    Modo := '2';
  end;
  Cabecera := 'PERS welddata ';

  if chkUseTask.Checked then
  begin
    Cabecera := 'TASK PERS welddata ';
  end;
  MainFrm.mnDatos.Lines.Add('!---------------------------');
  for I := spMinimo.Value to spMaximo.Value do
  begin
    {    TASK PERS welddata wd40_12:=[12,0,[40,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];}

    Cadena := Cabecera + edPrefijoSoldadura.Text + IntToStr(I) + ':=';
    Cadena := Cadena + '[' + IntToStr(I) + ',0,[' + programa + ',' + Modo +
      ',0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];';
   MainFrm.mnDatos.Lines.Add(Cadena);
  end;
end;

end.
