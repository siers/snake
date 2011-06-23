unit game;

interface

uses
    snake, screen, crt;

type
    TGame = class
        field:  TCoord;
        snake:  TSnake;
        screen: TScreen;
        food:   TObstacle;
        bounds: TBoundaries;
        constructor create;
        procedure   run;
        destructor  destroy; override;
    end;

const
    BTN_LEFT    = 75;
    BTN_UP      = 72;
    BTN_RIGHT   = 77;
    BTN_DOWN    = 80;

implementation

constructor TGame.create;
var
    beginning: TCoord;
begin
    screen      := TScreen.create;
    field       := screen.max;
    beginning.x := field.x div 2;
    beginning.y := field.y div 2;
    snake       := TSnake.create(beginning);
    bounds      := TBoundaries.create(1, 2, screen.max.x, screen.max.y);
    screen.pixel(beginning);
end;

procedure TGame.run;
var
    c: char;
    n: TSnakeCoord; // New head/tail coord.
    step: DWORD = 0;
    speed: integer = 5;
    growth: boolean;
    playing: boolean = true;
begin
    repeat
        delay(1000 div (speed * speed));
        while screen.has_input do begin
            c := screen.input;
            case ord(c) of
                BTN_LEFT, ord('a'): begin
                    snake.vec.x := -1;
                    snake.vec.y := 0;
                end;
                BTN_UP, ord('w'): begin
                    snake.vec.x := 0;
                    snake.vec.y := -1;
                end;
                BTN_RIGHT, ord('d'): begin
                    snake.vec.x := 1;
                    snake.vec.y := 0;
                end;
                BTN_DOWN, ord('s'): begin
                    snake.vec.x := 0;
                    snake.vec.y := 1;
                end;
                $31..$39: speed := ord(c) - $30;
            end;
        end;
        if playing then begin
            inc(step);
            growth := step < 5;
            n := snake.move(growth);
            if bounds.interferes(n.head) or snake.is_snake(n.head) then begin
                playing := false;
            end else begin
                screen.pixel(n.head);
                if not growth then
                    screen.pixel(n.tail, ' ');
            end;
        end;
    until c = 'q';
end;

destructor TGame.destroy;
begin
    bounds.free;
    screen.free;
    snake.free;
    inherited;
end;

initialization

finalization

end.
