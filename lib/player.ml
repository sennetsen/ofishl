(* Graphics library link for easy access:
   https://ocaml.github.io/graphics/graphics/Graphics/ *)
open Graphics

module type Player = sig
  val move : status -> unit
end

module Player = struct
  let move (input : status) : unit =
    let key = input.key in
    (match key with
    | 'w' -> Graphics.rmoveto 0 10
    | 'a' -> Graphics.rmoveto ~-10 0
    | 's' -> Graphics.rmoveto 0 ~-10
    | 'd' -> Graphics.rmoveto 10 0
    | _ -> ());
    let x = current_x () in
    let y = current_y () in
    Graphics.clear_graph ();
    fill_circle x y 3
end
