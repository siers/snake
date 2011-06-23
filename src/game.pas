unit game;

interface

uses
    snake, screen, crt, sysutils;

type
    TGame = class
        field:  TCoord;
        snake:  TSnake;
        screen: TScreen;
        food:   TObstacle;
        bounds: TBoundaries;
        constructor create;
        function    run: boolean;
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
    food        := TObstacle.create;
    screen.pixel(beginning);
end;

function TGame.run: boolean;
var
    c: char;
    n: TSnakeCoord; // New head/tail coord.
    ate: boolean = true;
    step: DWORD = 0;
    foodc: TCoord;
    score: integer = 0;
    speed: integer = 5;
    growth: boolean;
    playing: boolean = true;
    direction: byte = BTN_RIGHT;
begin
    screen.status('Welcome to the snake!', '');
    repeat
        screen.status('', 'Speed: ' + IntToStr(speed) +
            ' | Score: ' + IntToStr(score));
        screen.cursor(screen.max.x, 1);
        delay(1000 div (speed * speed));
        while screen.has_input do begin
            c := screen.input;
            case ord(c) of
                BTN_LEFT, ord('a'): begin
                    if direction <> BTN_RIGHT then begin
                        snake.vec.x := -1;
                        snake.vec.y := 0;
                    end;
                    direction := BTN_LEFT;
                end;
                BTN_UP, ord('w'): begin
                    if direction <> BTN_DOWN then begin
                        snake.vec.x := 0;
                        snake.vec.y := -1;
                    end;
                    direction := BTN_UP;
                end;
                BTN_RIGHT, ord('d'): begin
                    if direction <> BTN_LEFT then begin
                        snake.vec.x := 1;
                        snake.vec.y := 0;
                    end;
                    direction := BTN_RIGHT;
                end;
                BTN_DOWN, ord('s'): begin
                    if direction <> BTN_UP then begin
                        snake.vec.x := 0;
                        snake.vec.y := 1;
                    end;
                    direction := BTN_DOWN;
                end;
                $31..$39: speed := ord(c) - $30;
                ord('r'): begin
                    result := false;
                    exit;
                end;
            end;
        end;
        if playing then begin
            inc(step);
            growth := (step < 5) or ate;
            if ate then begin
                repeat
                    foodc.x := random(screen.max.x) + 1;
                    foodc.y := random(screen.max.y - 1) + 2;
                until not snake.is_snake(foodc);
                ate := false;
                screen.pixel(foodc, '.');
            end;
            n := snake.move(growth);
            if (n.head.x = foodc.x) and (n.head.y = foodc.y) then begin
                ate := true;
                score := score + speed;
            end;
            if bounds.interferes(n.head) or snake.is_snake(n.head) then begin
                playing := false;
                screen.status('You lost! Press q to exit or r to restart,', '');
            end else begin
                screen.pixel(n.head);
                if not growth then
                    screen.pixel(n.tail, ' ');
            end;
        end;
    until c = 'q';
    result := true;
end;

destructor TGame.destroy;
begin
    bounds.free;
    screen.free;
    snake.free;
    food.free;
    inherited;
end;

initialization

finalization

end.
