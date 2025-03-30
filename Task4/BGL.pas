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
procedure Line(x1, y1, x2, y2: integer);

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

procedure Line(x1, y1, x2, y2: integer);
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

procedure Draw;
begin
    Display.Draw;
end;

begin
    SetColor(Black);
    SetBkColor(White);
    ClearDevice;
end.