unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, class_pmac, class_reader;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnCreate: TButton;
    BtnExecute: TButton;
    EdtDimension: TEdit;
    EdtV: TEdit;
    LblDimension: TLabel;
    LblU: TLabel;
    LblBase: TLabel;
    Panel1: TPanel;
    SGBase: TStringGrid;
    procedure BtnCreateClick(Sender: TObject);
    procedure BtnExecuteClick(Sender: TObject);
  private
    Project: CProject;
    reader: CReader;
    function readRealMatrix(Grid: TStringGrid): realMatrix;
    function readStringMatrix(Grid: TStringGrid): stringMatrix;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BtnCreateClick(Sender: TObject);
begin
  SGBase.RowCount:= (StrToInt(EdtDimension.Text)) - 1;
  SGBase.ColCount:= 1;
end;

procedure TForm1.BtnExecuteClick(Sender: TObject);
var x: stringMatrix;
  v: realMatrix;
  u: string;
begin
  x:= readStringMatrix(SGBase);
  reader.sizeMatrix(EdtV.Text);//reader (size)
  v:= reader.StringToMatrix(EdtV.Text);//reader
  Project:= CProject.create;
  Project.n:= (StrToInt(EdtDimension.Text)) - 1;
  u:= Project.Execute(x,v);
  LblU.Caption:= 'u = ' + u;
end;

function TForm1.readRealMatrix(Grid: TStringGrid): realMatrix;
var
  cols,rows: Integer;
  i,j: Integer;
begin
  cols:= Grid.ColCount;
  rows:= Grid.RowCount;;
  SetLength(Result,rows,cols);

  for i:=0 to rows-1 do
  begin
    for j:=0 to cols-1 do
        Result[i,j]:= StrToFloat(Grid.Cells[j,i]);
  end;
end;

function TForm1.readStringMatrix(Grid: TStringGrid): stringMatrix;
var
  cols,rows: Integer;
  i,j: Integer;
begin
  cols:= Grid.ColCount;
  rows:= Grid.RowCount;;
  SetLength(Result,rows,cols);

  for i:=0 to rows-1 do
  begin
    for j:=0 to cols-1 do
        Result[i,j]:= Grid.Cells[j,i];
  end;
end;

end.

