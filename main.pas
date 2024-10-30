{ Icono de la aplicación
  https://www.flaticon.com/free-icon/robot_14599952?term=robot+weld&page=1&position=4&origin=search&related_id=14599952
}
unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, Menus, usplashabout, DefaultTranslator, LCLTranslator;

type

  { TmainFrm }

  TmainFrm = class(TForm)
    menus: TMainMenu;
    mnFileMenu: TMenuItem;
    mnQuit: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    mnExportToExistingModule: TMenuItem;
    mnExportoToNewModule: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Separator1: TMenuItem;
    mnSksStandard: TMenuItem;
    mnHelp: TMenuItem;
    mnOpenHelp: TMenuItem;
    mnAbout: TMenuItem;
    mnFronius: TMenuItem;
    mnDatos: TMemo;
    SplashAbout1: TSplashAbout;
    procedure FormCreate(Sender: TObject);
    procedure mnExportToExistingModuleClick(Sender: TObject);
    procedure mnFileMenuClick(Sender: TObject);
    procedure mnQuitClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure mnExportoToNewModuleClick(Sender: TObject);
    procedure mnSksStandardClick(Sender: TObject);
    procedure mnAboutClick(Sender: TObject);
    procedure mnDatosChange(Sender: TObject);
    procedure mnFroniusClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    procedure AddWeldData(var Archivo: TStringList);
  public
    procedure Copiar;
  end;

var
  mainFrm: TmainFrm;


implementation

uses weldFronius, SksStandard, ayuda, StrUtils;
  {$R *.lfm}

  { TmainFrm }
var
  FroniusFr: TFroniusFr;
  SksFr: TSksStandardFrm;

procedure TmainFrm.FormCreate(Sender: TObject);
begin
  FroniusFr := TFroniusFr.Create(Self);
  FroniusFr.Parent := Self;
  FroniusFr.Align := alTop;
  FroniusFr.BringToFront;

  SksFr := TSksStandardFrm.Create(Self);
  SksFr.Parent := self;
  SksFr.Hide;
  SksFr.Align := alTop;
end;

procedure TmainFrm.mnExportToExistingModuleClick(Sender: TObject);
var
  Fichero, FicheroNuevo: TStringList;
  I: integer;
  Cadena: string;
begin
  OpenDialog1.Title := mnExportToExistingModule.Caption;
  if OpenDialog1.Execute then
  begin
    Fichero := TStringList.Create;
    FicheroNuevo := TStringList.Create;
    try
      Fichero.LoadFromFile(OpenDialog1.FileName);
      for I := 0 to Fichero.Count - 1 do
      begin
        FicheroNuevo.Add(Fichero[I]);
        Cadena := Trim(Fichero[I]);
        if PosEx('MODULE ', Cadena) = 1 then
        begin
         AddWeldData(FicheroNuevo);
        end;
      end;
      FicheroNuevo.SaveToFile(OpenDialog1.FileName);
    finally
      FreeAndNil(FicheroNuevo);
      FreeAndNil(Fichero);
    end;
  end;
end;

procedure TmainFrm.mnFileMenuClick(Sender: TObject);
begin
  mnExportoToNewModule.Enabled := Length(mnDatos.Text) > 0;
  mnExportToExistingModule.Enabled:=Length(mnDatos.Text) > 0;
end;

procedure TmainFrm.mnQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TmainFrm.MenuItem4Click(Sender: TObject);
begin

end;

procedure TmainFrm.mnExportoToNewModuleClick(Sender: TObject);
var
  Fichero: TStringList;
  Extension, NombreModulo, Cabecera: string;
begin
  SaveDialog1.Title := mnExportoToNewModule.Caption;
  if SaveDialog1.Execute then
  begin
    Fichero := TStringList.Create;

    Extension := ExtractFileExt(SaveDialog1.FileName);
    NombreModulo := ExtractFileName(SaveDialog1.FileName);
    NombreModulo := ExtractWord(1, NombreModulo, ['.']);
    Cabecera := 'MODULE ' + NombreModulo;
    if CompareText(Extension, '.sys') = 0 then
    begin
      Cabecera := Cabecera + ' (SYSMODULE)';
    end;
    try
      Fichero.Add(Cabecera);
      AddWeldData(Fichero);
      Fichero.Add('ENDMODULE');
      Fichero.SaveToFile(SaveDialog1.FileName);
    finally
      FreeAndNil(Fichero);
    end;

  end;
end;



procedure TmainFrm.mnSksStandardClick(Sender: TObject);
begin

  FroniusFr.Hide;
  SksFr.Show;
  SksFr.BringToFront;
end;

procedure TmainFrm.mnAboutClick(Sender: TObject);
begin
  SplashAbout1.ShowAbout;
end;

procedure TmainFrm.mnDatosChange(Sender: TObject);
begin
  if FroniusFr <> nil then
  begin
    FroniusFr.ButtonCopiar.Enabled := mnDatos.Lines.Count > 0;
  end;
  if SksFr <> nil then
  begin
    SksFr.btGenerar.Enabled := mnDatos.Lines.Count > 0;
  end;
end;

procedure TmainFrm.mnFroniusClick(Sender: TObject);
begin
  sksfr.Hide;
  FroniusFr.Show;
  FroniusFr.BringToFront;
end;

procedure TmainFrm.SpeedButton1Click(Sender: TObject);
begin
  AyudaFrm.ShowModal;
end;

procedure TmainFrm.AddWeldData(var Archivo: TStringList);
begin
  with Archivo do
  begin
    Add('');
    Add('! ' + Self.Caption);
    Add('! Date: ' + DateToStr(Now()));
    Add('! Time: ' + TimeToStr(Time()));
    Add('! ');
    Add(mnDatos.Text);
    Add('! ');
  end;
end;

procedure TmainFrm.Copiar;
begin
  mnDatos.SelectAll;
  mnDatos.CopyToClipboard;
end;

end.
