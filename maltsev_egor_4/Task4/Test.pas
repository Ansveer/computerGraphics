program Test;

uses
    BGL;

var
    i: integer;
    T1, T2: integer;
    p: tPoly;

begin
    //T1 := milliseconds;
    //for i := 1 to 2000000 do begin
    //    SetColor(random(256*256*256));
    //    Line(random(SizeX), random(SizeY), random(SizeX), random(SizeY));
    //end;
    //T2 := milliseconds;
    
//    SetColor(Red);
//    HLine(50, 100, 200);
//    VLine(200, 100, 200);
//    HLine(200, 200, 100);
//    VLine(100, 200, 150);
//    HLine(100, 150, 50);
//    VLine(50, 150, 100);
//    SetColor(Blue);
//    FloodFill(190, 190, Red);
    //for i := 0 to SizeY div 2 do
    //    HLine(0, i, SizeX div 2);
    
    SetColor(Red);
    SetLength(p, 26);
    p[0].x := 100;
    p[0].y := 100;
    p[1].x := 100;
    p[1].y := 200;
    p[2].x := -100;
    p[2].y := 200;
    p[3].x := -100;
    p[3].y := GetMaxY + 100;
    p[4].x := 400;
    p[4].y := GetMaxY + 100;
    p[5].x := 400;
    p[5].y := GetMaxY - 100;
    p[6].x := 500;
    p[6].y := GetMaxY - 100;
    p[7].x := 500;
    p[7].y := GetMaxY + 100;
    p[8].x := GetMaxX + 100;
    p[8].y := GetMaxY + 100;
    p[9].x := GetMaxX + 100;
    p[9].y := 200;
    p[10].x := GetMaxX - 100;
    p[10].y := 200;
    p[11].x := GetMaxX - 100;
    p[11].y := 100;
    p[12].x := GetMaxX + 100;
    p[12].y := 100;
    p[13].x := GetMaxX + 100;
    p[13].y := -100;
    p[14].x := 500;
    p[14].y := -100;
    p[15].x := 500;
    p[15].y := 100;
    p[16].x := 400;
    p[16].y := 100;
    p[17].x := 400;
    p[17].y := -100;
    p[18].x := -75;
    p[18].y := -100;
    p[19].x := -75;
    p[19].y := -200;
    p[20].x := GetMaxX + 200;
    p[20].y := -200;
    p[21].x := GetMaxX + 200;
    p[21].y := GetMaxY + 200;
    p[22].x := -200;
    p[22].y := GetMaxY + 200;
    p[23].x := -200;
    p[23].y := -75;
    p[24].x := -100;
    p[24].y := -75;
    p[25].x := -100;
    p[25].y := 100;
    
    FillPoly(26, p);
    
//    SetColor(Red);
//    SetLength(p, 8);
//    p[0].x := 100;
//    p[0].y := 100;
//    p[1].x := 100;
//    p[1].y := 200;
//    p[2].x := -200;
//    p[2].y := 200;
//    p[3].x := -200;
//    p[3].y := -200;
//    p[4].x := 100;
//    p[4].y := -200;
//    p[5].x := 100;
//    p[5].y := -100;
//    p[6].x := -100;
//    p[6].y := -100;
//    p[7].x := -100;
//    p[7].y := 100;
  
//    FillPoly(8, p);
//    SetLength(p, 4);
//    p[0].x := 100;
//    p[0].y := 100;
//    p[1].x := -100;
//    p[1].y := 100;
//    p[2].x := -100;
//    p[2].y := -100;
//    p[3].x := 100;
//    p[3].y := -100;
//    
//    FillPoly(4, p);

    Draw;
end.
