program Test2;

uses
    BGL;
    
var
    p: tPoly;
    t1, t2: tPoint;

begin
    SetColor(Red);
    SetLength(p, 4);
    
    p[0].x := 100;
    p[0].y := 100;
    p[1].x := -200;
    p[1].y := 200;
    p[2].x := 100;
    p[2].y := 300;
    p[3].x := -100;
    p[3].y := 200;
    
    FillPoly(4, p);
    
//    SetLength(p, 8);
//    
//    p[0].x := 100;
//    p[0].y := 100;
//    p[1].x := 100;
//    p[1].y := 150;
//    p[2].x := 0;
//    p[2].y := 150;
//    p[3].x := 0;
//    p[3].y := 200;
//    p[4].x := 100;
//    p[4].y := 200;
//    p[5].x := 100;
//    p[5].y := 250;
//    p[6].x := -100;
//    p[6].y := 250;
//    p[7].x := -100;
//    p[7].y := 100;
//    
//    FillPoly(8, p);
    
//    SetLength(p, 4);
//    
//    p[0].x := 0;
//    p[0].y := 100;
//    p[1].x := -100;
//    p[1].y := 100;
//    p[2].x := -100;
//    p[2].y := 0;
//    p[3].x := 0;
//    p[3].y := 0;
//    
//    FillPoly(4, p);
    
//    SetLength(p, 4);
//    
//    p[0].x := 0;
//    p[0].y := 0;
//    p[1].x := 100;
//    p[1].y := 0;
//    p[2].x := 100;
//    p[2].y := -100;
//    p[3].x := 0;
//    p[3].y := -100;
//    
//    FillPoly(4, p);
    
//    SetLength(p, 4);
//    
//    p[0].x := 0;
//    p[0].y := GetMaxY;
//    p[1].x := 100;
//    p[1].y := GetMaxY;
//    p[2].x := 100;
//    p[2].y := GetMaxY + 100;
//    p[3].x := 0;
//    p[3].y := GetMaxY + 100;
//    
//    FillPoly(4, p);

//    SetLength(p, 2);
//    
//    p[0].x := 0;
//    p[0].y := 0;
//    p[1].x := 1;
//    p[1].y := 300;
//    
//    FillPoly(2, p);
    
//    SetLength(p, 3);
//    
//    p[0].x := -3;
//    p[0].y := 0;
//    p[1].x := 2;
//    p[1].y := 500;
//    p[2].x := -100;
//    p[2].y := 250;
//    
//    FillPoly(3, p);
    
//    SetLength(p, 2);
//    
//    p[0].x := GetMaxX;
//    p[0].y := 0;
//    p[1].x := GetMaxX;
//    p[1].y := 200;
//    
//    FillPoly(2, p);
    
//    SetLength(p, 4);
//    
//    p[0].x := 0;
//    p[0].y := 0;
//    p[1].x := 0;
//    p[1].y := 200;
//    p[2].x := -100;
//    p[2].y := 200;
//    p[3].x := -100;
//    p[3].y := 0;
//    
//    FillPoly(4, p);
    
//    SetLength(p, 1);
//    
//    p[0].x := 5;
//    p[0].y := 5;
//    
//    FillPoly(1, p);
    
    Draw;
end.