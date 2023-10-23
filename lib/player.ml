(* Graphics library link for easy access:
   https://ocaml.github.io/graphics/graphics/Graphics/ *)
open Graphics

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

let init (input : unit) =
  Graphics.open_graph " 750x750+500+500";
  Graphics.set_window_title "hai :3";
  Graphics.plot 10 10;
  Graphics.auto_synchronize true;
  Graphics.display_mode true;
  Graphics.loop_at_exit [ Key_pressed ] move
