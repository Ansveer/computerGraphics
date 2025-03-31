unit BGL;

interface

uses Display;

const
    Black = $000000;
    White = $FFFFFF;
    Red = $FF0000;
    Green = $00FF00;
    Blue = $0000FF;
    Yellow = $FFFF00;
    Magenta = $FF00FF;
    Cyan = $00FFFF;

    SizeX = Display.SizeX;
    SizeY = Display.SizeY;
    GetMaxX = Display.GetMaxX;
    GetMaxY = Display.GetMaxY;

procedure SetColor(C: tPixel);
procedure SetBkColor(C: tPixel);
procedure ClearDevice;

procedure PutPixel(x, y: integer; C: tPixel);

procedure LineDDA(x1, y1, x2, y2: integer);
procedure LinePP(x1, y1, x2, y2: integer);
procedure Line(x1, y1, x2, y2: integer);
procedure Circle(xc, yc, R: integer);

function GetPixel(x, y: integer): tPixel;
procedure FloodFillBad(x, y: integer; bord: tPixel);
procedure FloodFill(x, y: integer; bord: tPixel);

procedure HLine(x1, y, x2: integer);
procedure VLine(x, y1, y2: integer);

procedure Draw;

{=================================================================}

implementation

var
    CC, BC: tPixel;

procedure SetColor(C: tPixel);
begin
    CC := C;
end;

procedure SetBkColor(C: tPixel);
begin
    BC := C;
end;

procedure ClearDevice;
begin
    FillLB(0, SizeX*SizeY, BC);
end;

procedure PutPixel(x, y: integer; C: tPixel);
begin
    LB[SizeX*y + x] := C;
end;

procedure LineDDA(x1, y1, x2, y2: integer);
{ ЦДА }
var
    x, y, xend, yend: integer;
    dx, dy: integer;
    k, yf, xf: real;
begin
    dx := abs(x2 - x1);
    dy := abs(y2 - y1);
    if dx > dy then begin
        k := (y2 - y1)/(x2 - x1);
        if x1 < x2 then begin
            x := x1;
            xend := x2;
            yf := y1;
            end
        else begin
            x := x2;
            xend := x1;
            yf := y2;
        end;
        repeat
            PutPixel(x, round(yf), CC);
            x := x + 1;
            yf := yf + k;
        until x > xend;
    end
    else if dy > 0 then begin
        k := (x2 - x1)/(y2 - y1);
        if y1 < y2 then begin
            y := y1;
            yend := y2;
            xf := x1;
            end
        else begin
            y := y2;
            yend := y1;
            xf := x2;
        end;
        repeat
            PutPixel(round(xf), y, CC);
            y := y + 1;
            xf := xf + k;
        until y > yend;
    end
    else
        PutPixel(x1, y1, CC);
end;

procedure LinePP(x1, y1, x2, y2: integer);
{ Алгоритм Брезенхема }
var
    x, y, xend, yend, d: integer;
    dx, dy: integer;
    inc1, inc2: integer;
    s: integer;
begin
    dx := abs(x2 - x1);
    dy := abs(y2 - y1);
    if dx > dy then begin

        if x1 < x2 then begin 
            x := x1; xend := x2; y := y1; 
            if y2 >= y1 then s := 1 else s := -1; 
            end
        else begin 
            x := x2; xend := x1; y := y2;
            if y2 >= y1 then s := -1 else s := 1; 
            end;
        inc1 := 2*(dy - dx);
        inc2 := 2*dy;

        d := 2*dy - dx;
        PutPixel(x, y, CC);
        
        while x < xend do begin
            x := x + 1;
            if d > 0 then begin
                d := d + inc1;
                y := y + s;
            end
            else
                d := d + inc2;
            PutPixel(x, y, CC);
        end;
    end
    else begin

        if y1 < y2 then begin 
            y := y1; yend := y2; x := x1; 
            if x2 >= x1 then s := 1 else s := -1; 
            end
        else begin 
            y := y2; yend := y1; x := x2;
            if x2 >= x1 then s := -1 else s := 1; 
            end;
        inc1 := 2*(dx - dy);
        inc2 := 2*dx;

        d := 2*dx - dy;
        PutPixel(x, y, CC);
        
        while y < yend do begin
            y := y + 1;
            if d > 0 then begin
                d := d + inc1;
                x := x + s;
            end
            else
                d := d + inc2;
            PutPixel(x, y, CC);
        end;
    end;
end;

procedure Line(x1, y1, x2, y2: integer);
{ Алгоритм Брезенхема с вычислением адреса}
var
    d: integer;
    dx, dy: integer;
    inc1, inc2: integer;
    s, a, aend: integer;
begin
    dx := abs(x2 - x1);
    dy := abs(y2 - y1);
    if dx > dy then begin

        if x1 < x2 then begin 
            a := SizeX*y1 + x1; aend := SizeX*y2 + x2; 
            if y2 >= y1 then s := SizeX + 1 else s := -SizeX + 1; 
            end
        else begin 
            a := SizeX*y2 + x2; aend := SizeX*y1 + x1;
            if y2 >= y1 then s := -SizeX + 1 else s := SizeX + 1; 
            end;
        inc1 := 2*(dy - dx);
        inc2 := 2*dy;

        d := 2*dy - dx;
        LB[a] := CC;
        
        while a <> aend do begin
            if d > 0 then begin
                d := d + inc1;
                a := a + s;
            end
            else begin
                d := d + inc2;
                a := a + 1;
            end;
            LB[a] := CC;
        end;
    end
    else begin

        if y1 < y2 then begin 
            a := SizeX*y1 + x1; aend := SizeX*y2 + x2;
            if x2 >= x1 then s := SizeX + 1 else s := SizeX - 1;
            end
        else begin 
            a := SizeX*y2 + x2; aend := SizeX*y1 + x1;
            if x2 >= x1 then s := SizeX - 1 else s := SizeX + 1;
            end;
        inc1 := 2*(dx - dy);
        inc2 := 2*dx;

        d := 2*dx - dy;
        LB[a] := CC;
        
        while a <> aend do begin
            if d > 0 then begin
                d := d + inc1;
                a := a + s;
            end
            else begin
                d := d + inc2;
                a := a + SizeX;
            end;
            LB[a] := CC;
        end;
    end;
end;

procedure HLine(x1, y, x2: integer);
begin
    if x1 <= x2 then
        FillLB(SizeX*y + x1, x2-x1+1, CC)
    else
        FillLB(SizeX*y + x2, x1-x2+1, CC);
end;

procedure VLine(x, y1, y2: integer);
var
    a: integer;
    i: integer;
begin
    if y1 <= y2 then begin
        a := SizeX*y1 + x;
        for i := y1 to y2-1 do begin
            LB[a] := CC;
            a := a + SizeX;
        end
    end
    else begin
        a := SizeX*y2 + x;
        for i := y2 to y1-1 do begin
            LB[a] := CC;
            a := a + SizeX;
        end;
    end;
end;

procedure Pixel8(xc, yc, x, y: integer);
begin
    PutPixel(xc + x, yc + y, CC);
    PutPixel(xc - x, yc + y, CC);
    PutPixel(xc + x, yc - y, CC);
    PutPixel(xc - x, yc - y, CC);

    PutPixel(xc + y, yc + x, CC);
    PutPixel(xc - y, yc + x, CC);
    PutPixel(xc + y, yc - x, CC);
    PutPixel(xc - y, yc - x, CC);
end;

procedure Circle(xc, yc, R: integer);
var
    x, y: integer;
    d: integer;
begin
    d := 3 - 2*R;
    x := 0;
    y := R;
    Pixel8(xc, yc, x, R);
    while x < y do begin
        if d < 0 then
            d := d + 4*x + 6
        else begin
            d := d + 4*(x - y) + 10;
            y := y - 1;
        end;
        x := x + 1;
        Pixel8(xc, yc, x, y);
    end;
end;

function GetPixel(x, y: integer): tPixel;
begin
    GetPixel := LB[SizeX*y + x];
end;

procedure FloodFillBad(x, y: integer; bord: tPixel);
begin
    if (GetPixel(x, y) <> bord) and (GetPixel(x, y) <> CC) then begin
        PutPixel(x, y, CC);
        FloodFill(x+1, y, bord);
        FloodFill(x-1, y, bord);
        FloodFill(x, y+1, bord);
        FloodFill(x, y-1, bord);
    end;
end;

procedure FloodFill(x, y: integer; bord: tPixel);
var
    xl, xr: integer;
    yy: integer;
begin
    xl := x;
    while GetPixel(xl, y) <> bord do
        xl := xl - 1;
    xl := xl + 1;
    xr := x;
    while GetPixel(xr, y) <> bord do
        xr := xr + 1;
    xr := xr - 1;
    if xl < xr then
        HLine(xl, y, xr);
    
    yy := y - 1;
    repeat
        x := xr;
        while x >= xl do begin
            while (x >= xl) and ((GetPixel(x, yy) = bord) or (GetPixel(x, yy) = CC)) do
                x := x - 1;
            if x >= xl then
                FloodFill(x, yy, bord);
            x := x - 1;
        end;
        yy := yy + 2;
    until yy > y + 1;
end;

procedure Draw;
begin
    Display.Draw;
end;

begin
    SetColor(Black);
    SetBkColor(White);
    ClearDevice;
end.