//Histogram - rozciąganie histogramu
//(c) 2005 Tomasz Lubinski
//www.algorytm.org
 
unit Unit1;
 
interface
 
uses
Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
OleCtrls, chartfx3, jpeg, ExtCtrls, StdCtrls, TeeProcs, TeEngine, Chart,
Series, ComCtrls;
 
type
LUTType = Array[0..255] of Double;
 
TForm1 = class(TForm)
Button1: TButton;
ObrazKolorowy: TImage;
Histogram1: TChart;
Series1: TLineSeries;
Series2: TLineSeries;
Series3: TLineSeries;
ObrazMono: TImage;
Histogram2: TChart;
LineSeries1: TLineSeries;
Chart3: TChart;
LineSeries2: TLineSeries;
WynikKolorowy: TImage;
WynikMono: TImage;
Series4: TLineSeries;
Series5: TLineSeries;
Series6: TLineSeries;
procedure Button1Click(Sender: TObject);
procedure UpdateLUT(a: double; b: integer; var LUT: LUTType; series: Integer);
private
{ Private declarations }
public
{ Public declarations }
end;
 
var
Form1: TForm1;
LUTr, LUTg, LUTb, LUTgray: LUTType;
 
implementation
 
{$R *.DFM}
 
procedure TForm1.Button1Click(Sender: TObject);
var
i, j, rvalue, gvalue, bvalue, grayvalue: Integer;
rmin, gmin, bmin, graymin, rmax, gmax, bmax, graymax: Integer;
r, g, b, gray: Array [0..255] of Double;
color: TColor;
begin
for i := 0 to 255 do
begin
r[i] := 0;
g[i] := 0;
b[i] := 0;
gray[i] := 0;
end;
 
//znajdz minimum i maksimum kazdej skladowej
rmin := 255;
gmin := 255;
bmin := 255;
graymin := 255;
rmax := 1;
gmax := 1;
bmax := 1;
graymax := 1;
for i := 0 to ObrazKolorowy.Width-1 do
for j := 0 to ObrazKolorowy.Height-1 do
begin
color := ObrazKolorowy.Canvas.Pixels[i,j];
rvalue := GetRValue(color);
gvalue := GetGValue(color);
bvalue := GetBValue(color);
if rvalue > rmax then rmax := rvalue;
if gvalue > gmax then gmax := gvalue;
if bvalue > bmax then bmax := bvalue;
if rvalue < rmin then rmin := rvalue;
if gvalue < gmin then gmin := gvalue;
if bvalue < bmin then bmin := bvalue;
end;
for i := 0 to ObrazMono.Width-1 do
for j := 0 to ObrazMono.Height-1 do
begin
color := ObrazMono.Canvas.Pixels[i,j];
grayvalue := GetRValue(color);
if grayvalue > graymax then graymax := grayvalue;
if grayvalue < graymin then graymin := grayvalue;
end;
 
//przelicz tablice LUT, tak by rozciagnac histogram
updateLUT(255/(rmax-rmin), -rmin, LUTr, 1);
updateLUT(255/(gmax-gmin), -gmin, LUTg, 2);
updateLUT(255/(bmax-bmin), -bmin, LUTb, 3);
updateLUT(255/(graymax-graymin), -graymin, LUTgray, 0);
 
for i := 0 to ObrazKolorowy.Width-1 do
for j := 0 to ObrazKolorowy.Height-1 do
begin
color := ObrazKolorowy.Canvas.Pixels[i,j];
rvalue := GetRValue(color);
gvalue := GetGValue(color);
bvalue := GetBValue(color);
//zmien wartosc wedlug tablicy LUT
color := Round(LUTr[rvalue]) +
(Round(LUTg[gvalue]) shl 8) +
(Round(LUTb[bvalue]) shl 16);
//oblicz histogram
WynikKolorowy.Canvas.Pixels[i,j] := color;
r[GetRValue(color)] := r[GetRValue(color)] + 1;
g[GetGValue(color)] := g[GetGValue(color)] + 1;
b[GetBValue(color)] := b[GetBValue(color)] + 1;
end;
Histogram1.SeriesList.Series[0].Clear;
Histogram1.SeriesList.Series[1].Clear;
Histogram1.SeriesList.Series[2].Clear;
Histogram1.SeriesList.Series[0].AddArray(r);
Histogram1.SeriesList.Series[1].AddArray(g);
Histogram1.SeriesList.Series[2].AddArray(b);
 
for i := 0 to ObrazMono.Width-1 do
for j := 0 to ObrazMono.Height-1 do
begin
color := ObrazMono.Canvas.Pixels[i,j];
grayvalue := GetRValue(color);
//zmien wartosc wedlug tablicy LUT
color := Round(LUTgray[grayvalue]) +
(Round(LUTgray[grayvalue]) shl 8) +
(Round(LUTgray[grayvalue]) shl 16);
//oblicz histogram
WynikMono.Canvas.Pixels[i,j] := color;
gray[GetRValue(color)] := gray[GetRValue(color)] + 1;
end;
Histogram2.SeriesList.Series[0].Clear;
Histogram2.SeriesList.Series[0].AddArray(gray);
end;
 
//zmień wartosc jasnosci i kontrastu
//przelicz nowe wartosci tablicy LUT
//wyswietl wartosci tablicy LUT
procedure TForm1.UpdateLUT(a: double; b: integer; var LUT: LUTType; series: Integer);
var
i: Integer;
begin
for i := 0 to 255 do
if (a*(i+b)) > 255 then
LUT[i] := 255
else if (a*(i+b)) < 0 then
LUT[i] := 0
else
LUT[i] := (a*(i+b));
Chart3.SeriesList.Series[series].Clear;
Chart3.SeriesList.Series[series].AddArray(LUT);
end;
 
 
end.
