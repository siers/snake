Program chuuska;

(* Ģeniālā sekundārā objektu orientētā paskāla čūska. *)

uses
    game;

var
    g: TGame;

begin
    g := TGame.Create;
    g.run;
    g.Free;
end.
