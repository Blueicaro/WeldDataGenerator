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
unit SksStandard;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Spin;

type

  { TSksStandardFrm }

  TSksStandardFrm = class(TFrame)
    btGenerar: TButton;
    ButtonCopiar: TButton;
    chkAdd: TCheckBox;
    chkUseTask: TCheckBox;
    edPrefijoSoldadura: TEdit;
    LabelPart: TLabel;
    labelProgram: TLabel;
    Label1: TLabel;
    labelVelMaxima: TLabel;
    LabelMinimo: TLabel;
    LabelGroup: TLabel;
    Panel1: TPanel;
    spProgram: TSpinEdit;
    spMaximo: TSpinEdit;
    spMinimo: TSpinEdit;
    spGroup: TSpinEdit;
    spPartNo: TSpinEdit;
    procedure btGenerarClick(Sender: TObject);
    procedure LabelPartClick(Sender: TObject);
    procedure spGroupClick(Sender: TObject);
    procedure spMaximoClick(Sender: TObject);
  private
    procedure Validar;
    procedure Generar;
  public

  end;

implementation
uses main;
{$R *.lfm}

{ TSksStandardFrm }

procedure TSksStandardFrm.spGroupClick(Sender: TObject);
begin
  Validar;
end;

procedure TSksStandardFrm.spMaximoClick(Sender: TObject);
begin
  Validar;
end;

procedure TSksStandardFrm.LabelPartClick(Sender: TObject);
begin

end;

procedure TSksStandardFrm.btGenerarClick(Sender: TObject);
begin
  Generar;
end;

procedure TSksStandardFrm.Validar;
begin
  btGenerar.Enabled := (edPrefijoSoldadura.Text <> '') and
    (spMinimo.Value < spMaximo.Value);
end;

procedure TSksStandardFrm.Generar;

  function CalculoModo(aGroup: byte; aPartNo: byte): string;
  var
    Valor: integer;
  begin
    Valor := aGroup shl 5;
    Valor := Valor + aPartNo;
    Result := IntToStr(Valor);
  end;

var
  Cadena: string;
  I: integer;
  programa, Cabecera: string;
   Modo: string;
begin
  if not chkAdd.Checked then
  begin
    MainFrm.mnDatos.Clear;
  end;

  programa := '';
  programa := IntToStr(spProgram.Value);
  //Calculo Modo
  Modo := CalculoModo(spGroup.Value, spPartNo.Value);

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
