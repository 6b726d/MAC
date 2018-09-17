unit class_pmac;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, class_reader, class_matrix;

type
  CProject = class
    n: integer;//dimension
    function Execute(x: stringMatrix; v: realMatrix): string;
    function GramSchmidt(x: stringMatrix): stringMatrix;
    function ElementE(y: stringMatrix): stringMatrix;
    function ElementU(e: stringMatrix; v: realMatrix): string;
    private
      reader: CReader;
      opm: CMatrix;
  end;

implementation

function CProject.Execute(x: stringMatrix; v: realMatrix): string;
var y: stringMatrix;
  e: stringMatrix;
  u: string;
begin
  y:= GramSchmidt(x);
  e:= ElementE(y);
  u:= ElementU(e,v);
  Execute:= u;
end;

function CProject.GramSchmidt(x: stringMatrix): stringMatrix;
var y: stringMatrix;
  k,i: integer;
  yi: realMatrix;
  xk, yk: realMatrix;
  fn: real;//Numerador
  fd: real;//Denominador
  ft: real;//n/d
  ps: realMatrix;
  sum: realMatrix;
begin
  SetLength(y,n,1);
  for k:=0 to n-1 do
  begin
    xk:= reader.StringToMatrix(x[k,0]);
    sum:= opm.ZeroMatrix(sM[1]+1,(sM[0] div (sM[1]+1))+1);
    for i:=0 to k-1 do
    begin
      yi:= reader.StringToMatrix(y[i,0]);
      fn:= opm.DotProduct(xk,yi);
      fd:= opm.DotProduct(yi,yi);
      ft:= fn/fd;
      ps:= opm.ProductNumber(yi,ft);
      sum:= opm.Addition(sum,ps);
    end;
    yk:= opm.Subtraction(xk,sum);
    y[k,0]:= reader.MatrixToString(yk);
  end;
  GramSchmidt:= y;
end;

function CProject.ElementE(y: stringMatrix): stringMatrix;
var e: stringMatrix;
  i: integer;
  yi: realMatrix;
  ei: realMatrix;
begin
  SetLength(e,n,1);
  for i:=0 to n-1 do
  begin
    yi:= reader.StringToMatrix(y[i,0]);
    ei:= opm.DivisionNumber(yi,opm.Norm(yi));
    e[i,0]:= reader.MatrixToString(ei);
  end;
  ElementE:= e;
end;

function CProject.ElementU(e: stringMatrix; v: realMatrix): string;
var u: string;
  i: integer;
  ei: realMatrix;//Matriz ei
  dp: real;//Producto Punto
  ui: realMatrix;//Matriz ui
  sum: realMatrix;
begin
  sum:= opm.ZeroMatrix(sM[1]+1,(sM[0] div (sM[1]+1))+1);
  for i:=0 to n-1 do
  begin
    ei:= reader.StringToMatrix(e[i,0]);
    dp:= opm.DotProduct(v,ei);
    ui:= opm.ProductNumber(ei,dp);
    sum:= opm.Addition(sum,ui);
  end;
  u:= reader.MatrixToString(sum);
  ElementU:= u;
end;

end.

