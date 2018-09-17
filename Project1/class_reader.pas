unit class_reader;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, class_matrix;

type
  realMatrix = array of array of real;
  stringMatrix = array of array of string;

type
  CReader = class
    procedure sizeMatrix(s: String);
    function readNumber(s: String; pos: Integer; i: Integer): Integer;
    procedure tArray(s: String);
    function StringToMatrix(s: string): matrix;
    function MatrixToString(m: matrix): string;
  end;

implementation

procedure CReader.sizeMatrix(s: String);
var i: Integer;
    c: Integer;
    pc: Integer;
begin
 SetLength(sM,2);//Modificar
 c:= 0;
 pc:= 0;
 for i:=2 to Length(s) do
 begin
  if s[i]=',' then c+=1;
  if s[i]=';' then pc+=1;
 end;
 sM[0]:= c;
 sM[1]:= pc;
 SetLength(lM,sM[0]+sM[1]+1);
end;

function CReader.readNumber(s: String; pos: Integer; i: Integer): Integer;
var st: String;
begin
 st:= '';
 while ((s[pos]<>',') and (s[pos]<>';') and (s[pos]<>']')) do
 begin
  st:= st + s[pos] ;
  pos+=1;
 end;
 lM[i]:=StrToFloat(st);
 readNumber:= pos;
end;

procedure CReader.tArray(s: String);
var i: Integer;
    pos: Integer;
begin
 i:= 0;
 pos:= 2;
 while pos<Length(s) do
 begin
  pos:= readNumber(s,pos,i)+1;
  i+=1;
 end;
end;

function CReader.StringToMatrix(s: string): matrix;
var i: Integer;
    j: Integer;
    m: matrix;
begin
 sizeMatrix(s);
 tArray(s);
 SetLength(m,sM[1]+1,(sM[0] div (sM[1]+1))+1);
 for i:=0 to Length(m)-1 do
 begin
  for j:=0 to Length(m[0])-1 do
  begin
   m[i,j]:= lM[(i*Length(m[0]))+j];
  end;
 end;
 StringToMatrix:= m;
 SetLength(lM,0);
end;

function CReader.MatrixToString(m: matrix): string;
var i: Integer;
    j: Integer;
    s: string;
    lp: integer;//ultima posicion
begin
 tArray(s);
 s:= '[';
 for i:=0 to Length(m)-1 do
 begin
  for j:=0 to Length(m[0])-1 do
  begin
   s:= s + FloatToStr(m[i,j]) + ',';
  end;
  //Eliminar la ultima coma
  lp:= Length(s);
  s:= copy(s,1,lp-1);
  //
  s:= s + ';';
 end;
 //Eliminar el ultimo punto y coma
 lp:= Length(s);
 s:= copy(s,1,lp-1);
 //
 s:= s + ']';
 MatrixToString:= s;
end;

end.

