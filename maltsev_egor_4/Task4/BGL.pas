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

type
    tPoint = record
        x, y: integer;
    end;
    
    tPoly = array of tPoint;


procedure SetColor(C: tPixel);
procedure SetBkColor(C: tPixel);
procedure ClearDevice;

procedure PutPixel(x, y: integer; C: tPixel);
function GetPixel(x, y: integer): tPixel;

procedure LineDDA(x1, y1, x2, y2: integer);
procedure LinePP(x1, y1, x2, y2: integer);
procedure Line(x1, y1, x2, y2: integer);
procedure HLine(x1, y, x2: integer);
procedure VLine(x, y1, y2: integer);

procedure Circle(xc, yc, R: integer);

procedure DrawPoly(n : integer; xy : tPoly);
procedure FloodFill(x, y: integer; bord: tPixel);
procedure FillPoly(n: integer; p: tPoly);

procedure SetViewPort(xl, yt, xr, yb: integer);

procedure Draw;

{=================================================================}

implementation

const
    nmax = 100;

type
    tXbuf = record
        m: integer;
        x: array[1..nmax] of integer;
    end;
    
    tYXbuf = array[0..GetMaxY] of tXbuf;

var
    CC, BC: tPixel;
    YXbuf: tYXbuf;
    xleft, ytop, xright, ybottom: integer;

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
    FillLB(0, SizeX * SizeY, BC);
end;

procedure DrawPutPixel(x, y: integer; C: tPixel);
begin
    LB[SizeX * y + x] := C;
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
        k := (y2 - y1) / (x2 - x1);
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
        k := (x2 - x1) / (y2 - y1);
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
        inc1 := 2 * (dy - dx);
        inc2 := 2 * dy;
        
        d := 2 * dy - dx;
        PutPixel(x, y, CC);
        
        while x < xend do
        begin
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
        inc1 := 2 * (dx - dy);
        inc2 := 2 * dx;
        
        d := 2 * dx - dy;
        PutPixel(x, y, CC);
        
        while y < yend do
        begin
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

procedure DrawLine(x1, y1, x2, y2: integer);
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
            a := SizeX * y1 + x1; aend := SizeX * y2 + x2; 
            if y2 >= y1 then s := SizeX + 1 else s := -SizeX + 1; 
        end
        else begin
            a := SizeX * y2 + x2; aend := SizeX * y1 + x1;
            if y2 >= y1 then s := -SizeX + 1 else s := SizeX + 1; 
        end;
        inc1 := 2 * (dy - dx);
        inc2 := 2 * dy;
        
        d := 2 * dy - dx;
        LB[a] := CC;
        
        while a <> aend do
        begin
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
            a := SizeX * y1 + x1; aend := SizeX * y2 + x2;
            if x2 >= x1 then s := SizeX + 1 else s := SizeX - 1;
        end
        else begin
            a := SizeX * y2 + x2; aend := SizeX * y1 + x1;
            if x2 >= x1 then s := SizeX - 1 else s := SizeX + 1;
        end;
        inc1 := 2 * (dx - dy);
        inc2 := 2 * dx;
        
        d := 2 * dx - dy;
        LB[a] := CC;
        
        while a <> aend do
        begin
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
        FillLB(SizeX * y + x1, x2 - x1 + 1, CC)
    else
        FillLB(SizeX * y + x2, x1 - x2 + 1, CC);
end;

procedure VLine(x, y1, y2: integer);
var
    a: integer;
    i: integer;
begin
    if y1 <= y2 then begin
        a := SizeX * y1 + x;
        for i := y1 to y2 - 1 do
        begin
            LB[a] := CC;
            a := a + SizeX;
        end
    end
    else begin
        a := SizeX * y2 + x;
        for i := y2 to y1 - 1 do
        begin
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
    d := 3 - 2 * R;
    x := 0;
    y := R;
    Pixel8(xc, yc, x, R);
    while x < y do
    begin
        if d < 0 then
            d := d + 4 * x + 6
        else begin
            d := d + 4 * (x - y) + 10;
            y := y - 1;
        end;
        x := x + 1;
        Pixel8(xc, yc, x, y);
    end;
end;

function GetPixel(x, y: integer): tPixel;
begin
    GetPixel := LB[SizeX * y + x];
end;

procedure FloodFillBad(x, y: integer; bord: tPixel);
begin
    if (GetPixel(x, y) <> bord) and (GetPixel(x, y) <> CC) then begin
        PutPixel(x, y, CC);
        FloodFill(x + 1, y, bord);
        FloodFill(x - 1, y, bord);
        FloodFill(x, y + 1, bord);
        FloodFill(x, y - 1, bord);
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
        while x >= xl do
        begin
            while (x >= xl) and ((GetPixel(x, yy) = bord) or (GetPixel(x, yy) = CC)) do
                x := x - 1;
            if x >= xl then
                FloodFill(x, yy, bord);
            x := x - 1;
        end;
        yy := yy + 2;
    until yy > y + 1;
end;

//procedure Edge(x1, y1, x2, y2: integer);
//var
//    k, xf: double;
//    y, yend: integer;
//begin
//    k := (x2 - x1) / (y2 - y1);
//    if y1 < y2 then begin
//        y := y1; yend := y2; xf := x1; end
//    else begin
//        y := y2; yend := y1; xf := x2;
//    end;  
//    while y < yend do
//    begin
//        y := y + 1;
//        xf := xf + k;
////        if (YXbuf[y].m <> 0) and (YXbuf[y].x[YXbuf[y].m] = xf) then
////            continue;
//        inc(YXbuf[y].m);
//        YXbuf[y].x[YXbuf[y].m] := round(xf);
//    end
//end;

procedure Bresenham(x1, y1, x2, y2: integer);
{ Алгоритм Брезенхэма с сохранением растровой развертки }
var
   x, y, xend, yend: integer;
   d, inc1, inc2: integer;
   dx, dy: integer;
   s: integer;
begin
   dx := abs(x2 - x1);
   dy := abs(y2 - y1);
   if dx > dy then begin
      if x1 < x2 then begin
         x := x1;
         xend := x2;
         y := y1;
         if y1 <= y2 then 
            s := 1
         else
            s := -1
         end
      else begin
         x := x2;
         xend := x1;
         y := y2;
         if y1 > y2 then 
            s := 1
         else
            s := -1;
      end;
      inc1 := 2*dy;
      inc2 := 2*(dy-dx);
      d := 2*dy - dx;
      if s < 0 then begin
         inc(YXbuf[y].m);
         YXbuf[y].x[YXbuf[y].m] := x;
      end;   
      while x < xend do begin
         x := x + 1;
         if d < 0 then
            d := d + inc1
         else begin 
            y := y + s;
            d := d + inc2;
            inc(YXbuf[y].m);
            YXbuf[y].x[YXbuf[y].m] := x;
         end;
      end;
      if s < 0 then
         dec(YXbuf[y].m);
      end
   else begin
      if y1 < y2 then begin
         y := y1;
         yend := y2;
         x := x1;
         if x1 < x2 then 
            s := 1
         else
            s := -1;
         end
      else begin
         y := y2;
         yend := y1;
         x := x2;
         if x2 < x1 then 
            s := 1
         else
            s := -1;
      end;
      inc1 := 2*dx;
      inc2 := 2*(dx-dy);
      d := 2*dx - dy;
      while y < yend do begin
         y := y + 1;
         if d < 0 then
            d := d + inc1
         else begin 
            x := x + s;
            d := d + inc2
         end;
         inc(YXbuf[y].m);
         YXbuf[y].x[YXbuf[y].m] := x;
      end
   end;
end;

procedure Sort(var a: tXbuf);
var
    i, j, y: integer;
begin
    for i := 2 to a.m do
    begin
        y := a.x[i];
        j := i - 1;
        while (j > 0) and (y < a.x[j]) do
        begin
            a.x[j + 1] := a.x[j];
            j := j - 1;
        end;
        a.x[j + 1] := y;
    end;
end;

// тут
procedure DrawPoly(n : integer; xy : tPoly);
var
    x1, y1, x2, y2: integer;
    i  : integer;
begin
    x1 := xy[n - 1].x;
    y1 := xy[n - 1].y;
    for i := 0 to n-1 do begin
        x2 := xy[i].x;
        y2 := xy[i].y;
        if (n > 2) and (x1 = x2) and ((x1 = xleft) or (x1 = xright)) then begin
            x1 := x2;
            y1 := y2;
            continue;
        end
        else if (n > 2) and (y1 = y2) and ((y1 = ytop) or (y1 = ybottom)) then begin
            x1 := x2;
            y1 := y2;
            continue;
        end;
        Line(x1, y1, x2, y2);
        x1 := x2;
        y1 := y2;
    end;
end;

procedure VerticalEdge(x, n: integer; p: tPoly);
var
    i, y, x1, y1, x2, y2: integer;
    inside, draw: Boolean;
    inside1, inside2: Boolean;
begin
    for y := 0 to GetMaxY do begin
        x1 := p[n - 1].x;
        y1 := p[n - 1].y;
        draw := false;
        for i := 0 to (n - 1) do begin
            x2 := p[i].x;
            y2 := p[i].y;
            
            inside1 := ( ((y2 <= y) and (y < y1)) or ((y1 <= y) and (y < y2)) )
                        and (x = ( ( ((x1 - x2) * (y - y2)) div (y1 - y2) ) + x2 ));
            inside2 := ( ((y2 <= y) and (y < y1)) or ((y1 <= y) and (y < y2)) )
                        and (x = ( ( ((x2 - x1) * (y - y1)) div (y2 - y1) ) + x1 ));
            inside := inside1 or inside2; 
            
            if inside then
                draw := not draw;
            
            x1 := x2;
            y1 := y2;
        end;
        if draw then
            PutPixel(x, y, CC);
    end;
end;

procedure HorizontalEdge(y, n: integer; p: tPoly);
var
    i, x, x1, y1, x2, y2: integer;
    inside, draw, draw2: Boolean;
    inside1, inside2: Boolean;
    inside3, inside4, inside5: Boolean;
begin
    for x := 0 to GetMaxX do begin
        x1 := p[n - 1].x;
        y1 := p[n - 1].y;
        draw := false;
        draw2 := false;
        for i := 0 to (n - 1) do begin
            x2 := p[i].x;
            y2 := p[i].y;
            
            if y = 0 then begin
                inside3 := ( ((x2 <= x) and (x < x1)) or ((x1 <= x) and (x < x2)) )
                            and (y < ( ( ((y1 - y2) * (x - x2)) div (x1 - x2) ) + y2 ));
                inside4 := ( ((x2 <= x) and (x < x1)) or ((x1 <= x) and (x < x2)) )
                            and (y < ( ( ((y2 - y1) * (x - x1)) div (x2 - x1) ) + y1 ));
                inside5 := inside3 or inside4;
            end;
            
            inside1 := ( ((x2 <= x) and (x < x1)) or ((x1 <= x) and (x < x2)) )
                        and (y = ( ( ((y1 - y2) * (x - x2)) div (x1 - x2) ) + y2 ));
            inside2 := ( ((x2 <= x) and (x < x1)) or ((x1 <= x) and (x < x2)) )
                        and (y = ( ( ((y2 - y1) * (x - x1)) div (x2 - x1) ) + y1 ));
            inside := inside1 or inside2;
                       
            if inside then
                draw := not draw;
            
            if inside5 then
                draw2 := not draw2;
            
            x1 := x2;
            y1 := y2;
        end;
        if draw or draw2 then
            PutPixel(x, y, CC);
    end;
end;

procedure DrawEdges(n: integer; p: tPoly);
var
    i, j, k: integer;
    x, y: integer;
    x1, y1, x2, y2: integer;
    inside, draw: Boolean;
begin
    VerticalEdge(0, n, p);
    VerticalEdge(GetMaxX, n, p);
    HorizontalEdge(0, n, p);
    HorizontalEdge(GetMaxY, n, p);   
end;

// тут
procedure DrawFillPoly(n, nOrig: integer; p, pOrig: tPoly);
var
    y, ymin, ymax, i, i1, i2, j: integer;
begin
    ymin := p[0].y;
    ymax := ymin;
    for i := 0 to n - 1 do
        if p[i].y < ymin then
            ymin := p[i].y
        else if p[i].y > ymax then
            ymax := p[i].y;     
        
    for y := ymin to ymax do
        YXbuf[y].m := 0;
    
    i1 := n - 1;
    for i2 := 0 to n - 1 do
    begin
        if p[i1].y <> p[i2].y then
            Bresenham(p[i1].x, p[i1].y, p[i2].x, p[i2].y);
        i1 := i2;
    end;   
    
    for y := ymin to ymax do
    begin
        Sort(YXbuf[y]);
        i := 1;
        while i < YXbuf[y].m do
        begin
            if (YXbuf[y].x[i] = YXbuf[y].x[i + 1])
                and ((YXbuf[y].x[i] = xleft) or (YXbuf[y].x[i] = xright)) then begin
                i := i + 2;
                continue;
            end;
            HLine(YXbuf[y].x[i], y, YXbuf[y].x[i + 1]);
            i := i + 2;
        end;   
    end;
    
    DrawPoly(n, p);
    DrawEdges(nOrig, pOrig);
    Writeln('end');
end;

procedure SetViewPort(xl, yt, xr, yb: integer);
begin
    xleft := xl;
    ytop := yt;
    xright := xr;
    ybottom := yb;
end;

procedure Draw;
begin
    Display.Draw;
end;

procedure PutPixel(x, y: integer; C: tPixel);
begin
    x := x + xleft;
    y := y + ytop;
    if (x >= xleft) and (x <= xright) and (y >= ytop) and (y <= ybottom) then
        DrawPutPixel(x, y, C);
end;

function Coding(x, y: integer): integer;
var
    code: integer;
begin
    code := 0;
    if x < xleft then
        code := code + 8
    else if x > xright then
        code := code + 4;
    
    if y < ytop then
        code := code + 2
    else if y > ybottom then
        code := code + 1;
    Coding := code;
end;

procedure Line(x1, y1, x2, y2: integer);
var
    code1, code2: integer;
    inside: Boolean;
    x, y, code: integer;
begin
    x1 := x1 + xleft;
    x2 := x2 + xleft;
    y1 := y1 + ytop;
    y2 := y2 + ytop;
    code1 := Coding(x1, y1);
    code2 := Coding(x2, y2);
    inside := code1 or code2 = 0;
    while not inside and ((code1 and code2) = 0) do
    begin
        if code1 = 0 then begin
            x := x1; x1 := x2; x2 := x;
            y := y1; y1 := y2; y2 := y;
            code := code1; code1 := code2; code2 := code;
        end;
        
        if x1 < xleft then begin
            y1 := y1 + round((y2 - y1) / (x2 - x1) * (xleft - x1));
            x1 := xleft;
        end
        else if x1 > xright then begin
            y1 := y1 + round((y2 - y1) / (x2 - x1) * (xright - x1));
            x1 := xright;
        end
        else if y1 < ytop then begin
            x1 := x1 + round((x2 - x1) / (y2 - y1) * (ytop - y1));
            y1 := ytop;
        end
        else { y1 > ybottom} begin
            x1 := x1 + round((x2 - x1) / (y2 - y1) * (ybottom - y1));
            y1 := ybottom;
        end;
        code1 := Coding(x1, y1);
        inside := code1 or code2 = 0;            
    end;
    if inside then
        DrawLine(x1, y1, x2, y2);
end;

procedure ClipLeft(n: integer; p1: tPoly; var m: integer; var p2: tPoly);
var
    x1, y1, x2, y2: integer;
    i: integer;
    inside1, inside2: Boolean;
begin
    m := 0;
    x1 := p1[n - 1].x;
    y1 := p1[n - 1].y;
    inside1 := x1 >= xleft;
    for i := 0 to n - 1 do
    begin
        x2 := p1[i].x;
        y2 := p1[i].y;
        inside2 := x2 >= xleft;
        if inside1 <> inside2 then begin
            p2[m].y := y2 + round((y1 - y2) / (x1 - x2) * (xleft - x2));
            p2[m].x := xleft;
            m := m + 1;
        end;
        if inside2 then begin
            p2[m] := p1[i];
            m := m + 1;
        end;
        x1 := x2;
        y1 := y2;
        inside1 := inside2;
    end;
end;

procedure ClipRight(n: integer; p1: tPoly; var m: integer; var p2: tPoly);
var
    x1, y1, x2, y2: integer;
    i: integer;
    inside1, inside2: Boolean;
begin
    m := 0;
    x1 := p1[n - 1].x;
    y1 := p1[n - 1].y;
    inside1 := x1 <= xright;
    for i := 0 to n - 1 do
    begin
        x2 := p1[i].x;
        y2 := p1[i].y;
        inside2 := x2 <= xright;
        if inside1 <> inside2 then begin
            p2[m].y := y2 + round((y1 - y2)/(x1 - x2) * (xright - x2));
            p2[m].x := xright;
            m := m + 1;
        end;
        if inside2 then begin
            p2[m] := p1[i];
            m := m + 1;
        end;
        x1 := x2;
        y1 := y2;
        inside1 := inside2;
    end;
end;

procedure ClipTop(n: integer; p1: tPoly; var m: integer; var p2: tPoly);
var
    x1, y1, x2, y2: integer;
    i: integer;
    inside1, inside2: Boolean;
begin
    m := 0;
    x1 := p1[n - 1].x;
    y1 := p1[n - 1].y;
    inside1 := y1 >= ytop;
    for i := 0 to n - 1 do
    begin
        x2 := p1[i].x;
        y2 := p1[i].y;
        inside2 := y2 >= ytop;
        if inside1 <> inside2 then begin
            p2[m].x := x1 + round((x2 - x1) / (y2 - y1) * (ytop - y1));
            p2[m].y := ytop;
            m := m + 1;
        end;
        if inside2 then begin
            p2[m] := p1[i];
            m := m + 1;
        end;
        x1 := x2;
        y1 := y2;
        inside1 := inside2;
    end;
end;

procedure ClipBottom(n: integer; p1: tPoly; var m: integer; var p2: tPoly);
var
    x1, y1, x2, y2: integer;
    i: integer;
    inside1, inside2: Boolean;
begin
    m := 0;
    x1 := p1[n - 1].x;
    y1 := p1[n - 1].y;
    inside1 := y1 <= ybottom;
    for i := 0 to n - 1 do
    begin
        x2 := p1[i].x;
        y2 := p1[i].y;
        inside2 := y2 <= ybottom;
        if inside1 <> inside2 then begin
            p2[m].x := x1 + round((x2 - x1) / (y2 - y1) * (ybottom - y1));
            p2[m].y := ybottom;
            m := m + 1;
        end;
        if inside2 then begin
            p2[m] := p1[i];
            m := m + 1;
        end;
        x1 := x2;
        y1 := y2;
        inside1 := inside2;
    end;
end;

procedure Test(n: integer; p: tPoly);
begin
    for var i := 0 to n-1 do begin
        Writeln('x[', i, '] = ', p[i].x);
        Writeln('y[', i, '] = ', p[i].y);
    end;
end;

// тут
procedure FillPoly(n: integer; p: tPoly);
var
    p1, p2, pOrig: tPoly;
    m1, m2: integer;
    i: integer;
begin
    SetLength(p1, 2 * n);
    SetLength(p2, 2 * n);
    SetLength(pOrig, n);
    for i := 0 to n - 1 do begin
        pOrig[i].x := p[i].x + xleft;
        pOrig[i].y := p[i].y + ytop;
    end;

    ClipLeft(n, pOrig, m2, p2);
    if m2 > 0 then begin
        ClipTop(m2, p2, m1, p1);
        if m1 > 0 then begin
            ClipRight(m1, p1, m2, p2);
            if m2 > 0 then begin
                ClipBottom(m2, p2, m1, p1);
                if m1 > 0 then
                    DrawFillPoly(m1, n, p1, pOrig);
            end;
        end;
    end;
end;

begin
    SetColor(Black);
    SetBkColor(White);
    ClearDevice;
    SetViewPort(0, 0, GetMaxX, GetMaxY);
end.