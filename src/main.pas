Program chuuska;

(* Ģeniālā sekundārā objektu orientētā paskāla čūska. *)

uses
    game;

var
    g: TGame;
    die: boolean;
begin
    randomize;
    repeat
        g := TGame.Create;
        die := g.run;
        g.Free;
    until die;
end.
