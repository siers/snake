unit screen;

interface

uses
    crt, snake, sysutils;

type
    TScreen = class
        constructor create;
        procedure   pixel(x, y: integer; c: char = '#'); overload;
        procedure   pixel(p: TCoord; c: char = '#'); overload;
        procedure   cursor(x, y: integer);
        procedure   status(left, right: string);
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

procedure TScreen.status(left, right: string);
begin
    if left <> '' then begin
        cursor(1, 1);
        write(format('%-30s', [left]));
    end;
    if right <> '' then begin
        cursor(max.x - 30, 1);
        write(format('%30s', [right]));
    end;
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
    GotoXY(x, y);
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
