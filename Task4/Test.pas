program Test;

uses
    BGL;

var
    i: integer;
    T1, T2: integer;

begin
    T1 := milliseconds;
    for i := 1 to 1000000 do begin
        SetColor(random(256*256*256));
        Line(random(SizeX), random(SizeY), random(SizeX), random(SizeY));
    end;
    T2 := milliseconds;

    Draw;
end.
