program GeneradorWeldData;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, ayuda, SksStandard, weldFronius;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TmainFrm, mainFrm);
  Application.CreateForm(TAyudaFrm, AyudaFrm);
  Application.Run;
end.

