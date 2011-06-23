unit snake;

interface

uses
    classes, sysutils, types, typinfo, rtlconsts;

type
    TCoord = record
        x: integer;
        y: integer;
    end;
    PCoord = ^TCoord;
    TVector = TCoord;

    TSnakeCoord = record
        head: TCoord;
        tail: TCoord;
    end;

    TSnake = class
    private
        pieces:     TList;
        head:       TCoord;
    public
        vec:        TVector;
        len:        integer;
        constructor create(initc: TCoord);
        function    grow: TCoord;
        function    reduce: TCoord;
        function    move(growth: boolean): TSnakeCoord;
        function    is_snake(c: TCoord): boolean;
        destructor  destroy; override;
    end;

    obstacle_types = (fatal, edible, poisonous);

    TObstacle = class
        coord: TCoord;
        otype: obstacle_types;
        constructor create(c: TCoord);
        function    interferes(c: TCoord): boolean;
    end;

    TBoundaries = class(TObstacle)
        minx, miny, maxx, maxy: integer;
        constructor create(nx, ny, xx, xy: integer);
        function    interferes(c: TCoord): boolean;
    end;

implementation

constructor TSnake.create(initc: TCoord);
begin
    head := initc;
    vec.x   := 0;
    vec.y   := 0;
    pieces  := TList.Create;
    grow;
    vec.x   := 1;
end;

function TSnake.grow: TCoord;
var c: PCoord;
begin
    new(c);
    head.x := head.x + vec.x;
    head.y := head.y + vec.y;
    c^     := head;
    len := pieces.add(c) + 1;
    result := c^;
end;

function TSnake.reduce: TCoord;
begin
    result := (PCoord(pieces.list^[0]))^;
    dispose(PCoord(pieces.list^[0]));
    len := len - 1;
    pieces.delete(0);
end;

function TSnake.move(growth: boolean): TSnakeCoord;
begin
    if not growth then
        result.tail := reduce;
    result.head := grow;
end;

function TSnake.is_snake(c: TCoord): boolean;
var i: integer; c2: TCoord;
begin
    for i := 0 to pieces.count - 2 do begin
        c2 := (PCoord(pieces.list^[i]))^;
        if (c.x = c2.x) and (c.y = c2.y) then begin
            result := true;
            exit;
        end;
    end;
    result := false;
end;

destructor TSnake.destroy;
var i: integer;
begin
    for i := len downto 1 do
        reduce;
    inherited;
end;

constructor TObstacle.create(c: TCoord);
begin
    coord := c;
end;

function TObstacle.interferes(c: TCoord): boolean;
begin
    result := (c.x = coord.x) or (c.y = coord.y);
end;

constructor TBoundaries.create(nx, ny, xx, xy: integer);
begin
    minx := nx;
    miny := ny;
    maxx := xx;
    maxy := xy;
    otype:= fatal;
end;

function TBoundaries.interferes(c: TCoord): boolean;
begin
    result := not((c.x <= maxx) and (c.x >= minx) and (c.y <= maxy) and (c.y >= miny));
end;

initialization

finalization

end.
