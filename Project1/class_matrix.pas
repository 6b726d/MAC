unit class_matrix;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math;
type
  matrix = array of array of double;

type
  CMatrix = class
  public
  function Addition(m1: matrix; m2: matrix): matrix;
  function Subtraction(m1: matrix; m2: matrix): matrix;
  function Product(m1: matrix; m2: matrix): matrix;
  function ProductNumber(m1: matrix; n: Real): matrix;
  function DivisionNumber(m1: matrix; n: Real): matrix;
  function PowerMatrix(m1: matrix; n: Integer): matrix;
  function Transpose(m1: matrix): matrix;
  function Determinant(m1: matrix): Real;
  function Cofactor(m1: matrix): matrix;
  function Adjugate(m1: matrix): matrix;
  function Inverse(m1: matrix): matrix;
  function Division(m1: matrix; m2: matrix): matrix;
  function GJ(m1: matrix): matrix;
  function Traza(m1: matrix): Real;
  function DotProduct(m1: matrix; m2:matrix): Real;
  function Norm(m1:matrix): Real;
  function ZeroMatrix(r: integer; c:integer): matrix;

end;

var sM: array of integer;//',' ';'
  lM: array of double;//values of matrix

implementation

function CMatrix.Addition(m1: matrix; m2: matrix): matrix;
var m3: matrix;
  i,j: integer;
  col1, col2, row1, row2: integer;
begin
row1:= Length(m1);
col1:= Length(m1[0]);
row2:= Length(m2);
col2:= Length(m2[0]);

if (row1=row2) and (col1=col2) then
  begin
  SetLength(m3,row1,col1);

  for i:=0 to row1-1 do
  begin
    for j:=0 to col1-1 do
       m3[i,j]:= m1[i,j] + m2[i,j] ;
  end;
  Addition:= m3;
  end;
end;

function CMatrix.Subtraction(m1: matrix; m2: matrix): matrix;
var m3: matrix;
  i,j: integer;
  col1, col2, row1, row2: integer;
begin
row1:= Length(m1);
col1:= Length(m1[0]);
row2:= Length(m2);
col2:= Length(m2[0]);

if (row1=row2) and (col1=col2) then
  begin
  SetLength(m3,row1,col1);

  for i:=0 to row1-1 do
  begin
    for j:=0 to col1-1 do
       m3[i,j]:= m1[i,j] - m2[i,j];
  end;
  Subtraction:= m3;
  end;
end;

function CMatrix.Product(m1: matrix; m2: matrix): matrix;
var m3: matrix;
  i,j,k: integer;
  col1, col2, row1, row2: integer;
begin
row1:= Length(m1);
col1:= Length(m1[0]);
row2:= Length(m2);
col2:= Length(m2[0]);

if (col1=row2) then
 begin
 SetLength(m3,row1,col2);
 for i:=0 to row1-1 do
  begin
    for j:=0 to col2-1 do
    begin
      m3[i,j]:= 0;
      for k:=0 to col1-1 do
          m3[i,j]:= m3[i,j] + m1[i,k] * m2[k,j];
      end;
  end;
 Product:= m3;
 end;

end;

function CMatrix.ProductNumber(m1: matrix; n: Real): matrix;
var mr: matrix;
  i,j: Integer;
begin
     SetLength(mr, Length(m1), Length(m1[0]));
     for i:=0 to Length(m1)-1 do
         for j:=0 to Length(m1[0])-1 do
             mr[i,j]:= n*m1[i,j];

     ProductNumber:= mr;
end;

function CMatrix.DivisionNumber(m1: matrix; n: Real): matrix;
var mr: matrix;
  i,j: Integer;
begin
     SetLength(mr, Length(m1), Length(m1[0]));
     for i:=0 to Length(m1)-1 do
         for j:=0 to Length(m1[0])-1 do
             mr[i,j]:= m1[i,j]/n;

     DivisionNumber:= mr;
end;

function CMatrix.PowerMatrix(m1: matrix; n: Integer): matrix;
var mr: matrix;
  i,j: Integer;
begin
     SetLength(mr, Length(m1), Length(m1[0]));
     if (n = 0) then
     begin
        for i:=0 to Length(m1)-1 do
        begin
          for j:=0 to Length(m1[0])-1 do
          begin
            if i=j then
               mr[i,j]:= 1
            else
               mr[i,j]:= 0;
          end;
        end;
        PowerMatrix:= mr;
     end
     else
     begin
       mr:= m1;
       for i:=0 to n-1-1 do
           mr:= Product(mr,m1);

       PowerMatrix:= mr;
     end;
end;

function CMatrix.Transpose(m1: matrix): matrix;
var mr: matrix;
  cols, rows: Integer;
  i, j: Integer;
begin
  rows := Length(m1);
  cols := Length(m1[0]);


  SetLength(mr, cols, rows);

  for i:=0 to cols-1 do
      for j:= 0 to rows-1 do
         mr[i,j] := m1[j,i];

  Transpose:= mr;
end;

function CMatrix.Determinant(m1: matrix): Real;
var mt: matrix;
  i,j,k: Integer;
begin
  if (Length(m1) = 1) and (Length(m1[0]) = 1) then
     Determinant:= m1[0,0]
  else if (Length(m1) = 2) and (Length(m1[0]) = 2) then
       Determinant:= (m1[0,0]*m1[1,1] - m1[0,1]*m1[1,0])
  else
     begin
        SetLength(mt, Length(m1)-1, Length(m1[0])-1);
        for k:=0 to Length(m1[0])-1 do
            begin
              for i:=0 to Length(m1)-1 do
                 begin
                   if i=0 then continue;
                   for j:=0 to Length(m1[0])-1 do
                      begin
                        if j=k then continue
                        else if j<k then
                             mt[i-1,j]:= m1[i,j]
                        else if j>k then
                             mt[i-1,j-1]:= m1[i,j];
                      end;
                 end;
              Determinant:= Determinant + Power((-1),k)*m1[0,k] * Determinant(mt);
            end;
     end;
end;

function CMatrix.Cofactor(m1: matrix): matrix;
var mr: matrix;
  mt: matrix;
  i,j,k,l: Integer;
begin
  SetLength(mr, Length(m1), Length(m1[0]));
  if Length(m1) = 1 then
  begin
     mr[0,0]:= 1;
  end
  else
  begin
    SetLength(mt, Length(m1)-1, Length(m1[0])-1);

    for k:=0 to Length(m1)-1 do
       begin
         for l:=0 to Length(m1[0])-1 do
            begin
              for i:=0 to Length(m1)-1 do
                 begin
                   if i=l then continue;
                   for j:=0 to Length(m1[0])-1 do
                      begin
                        if j=k then continue
                        else if (i<l) and (j<k) then
                             mt[i,j]:= m1[j,i]
                        else if (i>l) and (j>k) then
                             mt[i-1,j-1]:= m1[j,i]
                        else if (i<l) and (j>k) then
                             mt[i,j-1]:= m1[j,i]
                        else if (i>l) and (j<k) then
                             mt[i-1,j]:= m1[j,i]
                      end;
                 end;
              mr[k,l]:= (Power(-1,k+l+2)) * Determinant(mt);
            end;
       end;
    end;
  Cofactor:= mr;
end;

function CMatrix.Adjugate(m1: matrix): matrix;
var cof: matrix;
begin
  cof:= Cofactor(m1);
  Adjugate:= Transpose(cof);
end;

function CMatrix.Inverse(m1: matrix): matrix;
var adj: matrix;
  det: Real;
begin
  det:= Determinant(m1);
  adj:= Adjugate(m1);
  Inverse:= DivisionNumber(adj,det);
end;

function CMatrix.Division(m1: matrix; m2: matrix): matrix;
var m3: matrix;
  col1, col2, row1, row2: integer;
begin
row1:= Length(m1);
col1:= Length(m1[0]);
row2:= Length(m2);
col2:= Length(m2[0]);

if (col1=row2) then
 begin
 SetLength(m3,row1,col2);
 m3:= Product(m1,Inverse(m2));
 Division:= m3;
 end;

end;

function CMatrix.GJ(m1: matrix): matrix;
var mr: matrix;
  t: Real;
  cols, rows: Integer;
  i,j,k: Integer;
begin
  rows := Length(m1);
  cols := Length(m1[0]);

  SetLength(mr, rows, cols);
  mr:= m1;
  for i:=0 to rows-2 do
     begin
       for k:=i+1 to rows-1 do
          begin
            t:= mr[k,i]/mr[i,i];
            for j:=0 to cols-1 do
               mr[k,j]:= mr[k,j] - (t*mr[i,j]);
          end;
     end;

  GJ:= mr;

end;

function CMatrix.Traza(m1: matrix): Real;
var trz: Real;
  cols, rows: Integer;
  i, j: Integer;
begin
  rows := Length(m1);
  cols := Length(m1[0]);
  trz:= 0;

  for i:=0 to rows-1 do
      for j:= 0 to cols-1 do
         if i=j then trz:= trz + m1[i,j];

  Traza:= trz;
end;

function CMatrix.DotProduct(m1: matrix; m2:matrix): real;
begin
     DotProduct:= Traza(Product(m1,Transpose(m2)));
end;

function CMatrix.Norm(m1: matrix): real;
begin
     Norm:= sqrt(Traza(Product(m1,Transpose(m1))));
end;

function CMatrix.ZeroMatrix(r: integer; c:integer): matrix;
var m: matrix;
  i,j: Integer;
begin
  SetLength(m,r,c);
  for i:=0 to r-1 do
      for j:= 0 to c-1 do
         m[i,j]:= 0;

  ZeroMatrix:= m;
end;

end.

