{ This file is part of Generador WeldData program

  Copyright (C) 2024 Jorge Turiel Fernández jorgeturiel@gmail.com

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
  Boston, MA 02110-1335, USA.
}
unit weldFronius;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Buttons, Spin;

type

  { TFroniusFr }

  TFroniusFr = class(TFrame)
    btGenerar: TButton;
    ButtonCopiar: TButton;
    chkAdd: TCheckBox;
    chkUseTask: TCheckBox;
    edPrefijoSoldadura: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Minimo: TLabel;
    Panel1: TPanel;
    spMaximo: TSpinEdit;
    spMinimo: TSpinEdit;
    procedure btGenerarClick(Sender: TObject);
    procedure ButtonCopiarClick(Sender: TObject);
    procedure edPrefijoSoldaduraChange(Sender: TObject);
    procedure spMaximoClick(Sender: TObject);
    procedure spMaximoEditingDone(Sender: TObject);
    procedure spMinimoClick(Sender: TObject);
  private
    procedure Validar;
    procedure Generar;
  public

  end;

implementation

uses main;
  {$R *.lfm}

  { TFroniusFr }

procedure TFroniusFr.btGenerarClick(Sender: TObject);
begin
  if btGenerar.Enabled then
    Generar;
end;

procedure TFroniusFr.ButtonCopiarClick(Sender: TObject);
begin
  mainfrm.Copiar;
end;

procedure TFroniusFr.edPrefijoSoldaduraChange(Sender: TObject);
begin
  Validar;
end;

procedure TFroniusFr.spMaximoClick(Sender: TObject);
begin
  Validar;
end;

procedure TFroniusFr.spMaximoEditingDone(Sender: TObject);
begin
  Validar;
end;

procedure TFroniusFr.spMinimoClick(Sender: TObject);
begin
  Validar;
end;

procedure TFroniusFr.Validar;
begin
  btGenerar.Enabled := (edPrefijoSoldadura.Text <> '') and
    (spMinimo.Value < spMaximo.Value);
end;

procedure TFroniusFr.Generar;
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
  Modo := '2';

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
    Cadena := Cadena + '[' + IntToStr(I) + ',0,[' + programa + ',' +
      Modo + ',0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];';
    MainFrm.mnDatos.Lines.Add(Cadena);
  end;
end;

end.
