// Copyright (c) 2012-2013, Jordi Corbilla
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// - Neither the name of this library nor the names of its contributors may be
// used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

unit thundax.ai.matrix;

interface

uses
  thundax.ai.matrix.arraytypes;

type
  TMultiArray = Array of array of Double;

  TMatrix = class(TObject)
  private
    FColumns: Integer;
    FRows : Integer;
    FMultiArray: TMultiArray;
    function GetCell(x, y: Integer): Double;
    procedure SetCell(x, y: Integer; const Value: Double);
  public
    constructor Create(Columns, Rows : Integer); overload;
    constructor Create(Columns : TArrayColumns); overload;
    procedure Initialise();
    property Columns: Integer read FColumns write FColumns;
    property Rows: Integer read FRows write FRows;
    function Transpose(): TMatrix;
    property Cell[x, y: Integer]: Double read GetCell write SetCell;
    function ToString() : string;
  end;

implementation

uses
  SysUtils, thundax.ai.matrix.Columns;

{ TMatrix }

constructor TMatrix.Create(Columns, Rows : Integer);
var
  i: Integer;
begin
  FRows := Rows;
  FColumns := Columns;
  SetLength(FMultiArray, FRows);
  for i := 0 to FRows - 1 do
    SetLength(FMultiArray[i], FColumns);
end;

constructor TMatrix.Create(Columns: TArrayColumns);
var
  i, j: Integer;
begin
  FRows := High(Columns[0].Values)+1;
  FColumns := High(Columns)+1;
  SetLength(FMultiArray, FRows);
  for i := 0 to FRows - 1 do
    SetLength(FMultiArray[i], FColumns);

  for i := 0 to FRows-1 do
    for j := 0 to FColumns-1 do
      SetCell(i,j,Columns[i].Values[j]);
end;

function TMatrix.GetCell(x, y: Integer): Double;
begin
  Result := FMultiArray[x, y];
end;

procedure TMatrix.Initialise;
var
  i: Integer;
begin
  for i := 0 to High(FMultiArray) - 1 do
  begin
    FMultiArray[0, i] := i;
    FMultiArray[i, 0] := i;
  end;
end;

procedure TMatrix.SetCell(x, y: Integer; const Value: Double);
begin
  FMultiArray[x, y] := Value;
end;

function TMatrix.ToString: string;
var
  i, j: Integer;
  sLine, sRowLine : string;
begin
  sRowLine := '';
  for i := 0 to Self.FRows - 1 do
  begin
    sLine := '';
    for j := 0 to Self.FColumns - 1 do
      sLine := sLine + FloatToStr(FMultiArray[j, i]) + '    ';
    sRowLine := sRowLine + sLine + sLineBreak;
  end;
  result := sRowLine;
end;

function TMatrix.Transpose: TMatrix;
var
  trasposed: TMatrix;
  i, j: Integer;
begin
  trasposed := TMatrix.Create(Self.FRows, Self.FColumns);
  for i := 0 to Self.FRows - 1 do
    for j := 0 to Self.FColumns - 1 do
      trasposed.Cell[i, j] := FMultiArray[j, i];
  result := trasposed;
end;

end.
