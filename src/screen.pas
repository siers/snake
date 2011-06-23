unit screen;

interface

uses
    crt, snake;

type
    TScreen = class
        constructor create;
        procedure   pixel(x, y: integer; c: char = '#'); overload;
        procedure   pixel(p: TCoord; c: char = '#'); overload;
        procedure   cursor(x, y: integer);
        function    has_input: boolean;
        function    input: char;
        function    max: TCoord;
        destructor  destroy; override;
    end;

implementation

constructor TScreen.create;
begin
    clrscr;
    cursoroff;
end;

procedure TScreen.pixel(x, y: integer; c: char = '#');
begin
    GotoXY(x, y);
    write(c);
end;

procedure TScreen.pixel(p: TCoord; c: char = '#');
begin
    GotoXY(p.x, p.y);
    write(c);
end;

procedure TScreen.cursor(x, y: integer);
begin
end;

function TScreen.has_input: boolean;
begin
    result := KeyPressed;
end;

function TScreen.input: char;
begin
    result := readkey;
end;

function TScreen.max: TCoord;
begin
    result.x := WindMaxX;
    result.y := WindMaxY;
end;

destructor TScreen.destroy;
begin
    cursoron;
    inherited;
end;

initialization

finalization

end.
