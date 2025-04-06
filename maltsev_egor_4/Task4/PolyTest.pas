program PolyTest;
uses
   BGL;
var
   p: tPoly;

procedure MakeStar(r1, r2 : real; n: integer; var s: tPoly);
var
   i           : integer;
   df, f1, f2  : real;
begin
   SetLength(s, 2*n);
   df := 2*Pi/n;
   f1 := Pi/2;
   f2 := f1 + df/2;
   for i := 0 to n-1 do begin
      s[2*i].x := round(r1*cos(f1));
      s[2*i].y := round(r1*sin(f1));
      s[2*i+1].x := round(r2*cos(f2));
      s[2*i+1].y := round(r2*sin(f2));
      f1 := f1 + df;
      f2 := f2 + df;
   end;
end;

procedure MovePoly(var p: tPoly; dx, dy: integer);
var
   i: integer;
begin
   for i := 0 to length(p)-1 do begin
      p[i].x := p[i].x + dx;
      p[i].y := p[i].y + dy;
   end;
end;

begin
   MakeStar(100, 250, 5, p);
//   MovePoly(p, GetMaxX div 2, GetMaxY div 2);

   SetColor(Red);
   
   FillPoly(10, p);
   
   
   Draw;
   
end.
