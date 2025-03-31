program Test;

uses
    BGL;

var
    i: integer;
    T1, T2: integer;

begin
    //T1 := milliseconds;
    //for i := 1 to 2000000 do begin
    //    SetColor(random(256*256*256));
    //    Line(random(SizeX), random(SizeY), random(SizeX), random(SizeY));
    //end;
    //T2 := milliseconds;
    
    SetColor(Red);
    HLine(50, 100, 200);
    VLine(200, 100, 200);
    HLine(200, 200, 100);
    VLine(100, 200, 150);
    HLine(100, 150, 50);
    VLine(50, 150, 100);
    SetColor(Blue);
    FloodFill(190, 190, Red);
    //for i := 0 to SizeY div 2 do
    //    HLine(0, i, SizeX div 2);

    Draw;
end.
