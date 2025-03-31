unit Display;

interface

const

    SizeX = 900;
    SizeY = 600;

    Size = SizeX*SizeY;
    GetMaxX = SizeX-1;
    GetMaxY = SizeY-1;

type
    tPixel = integer;
    tLBuffer = array [0..Size-1] of tPixel;

var
    LB: tLBuffer;

procedure Draw;
procedure FillLB(start: integer; count: integer; value: tPixel);

{======================================================================}

implementation

uses
    GraphABC;

var
    gr: System.Drawing.Graphics;
    bmp: System.Drawing.Bitmap;
    ptr: System.IntPtr;

procedure FillLB(start: integer; count: integer; value: tPixel);
begin
    for var i := start to start+count-1 do
        LB[i] := value;
end;

procedure Draw;
begin
    gr.DrawImage(bmp, 0, 0);
end;

begin
    SetWindowSize(SizeX, SizeY);
    Window.CenterOnScreen;
    SetWindowIsFixedSize(true);
    gr := GraphWindowGraphics;
    ptr := new System.IntPtr(@LB[0]);
    bmp := new System.Drawing.Bitmap(SizeX, SizeY, SizeX*4, System.Drawing.Imaging.PixelFormat.Format32bppRgb, ptr);
    SetGraphABCIO;
end.