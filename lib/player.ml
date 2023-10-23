(* Graphics library link for easy access:
   https://ocaml.github.io/graphics/graphics/Graphics/ *)
open Graphics

let move (input : status) : unit =
  let key = input.key in
  let x = current_x () in
  let y = current_y () in
  match key with
  | 'w' ->
      Graphics.moveto x (y + 10);
      fill_circle x (y + 10) 3
  | 'a' ->
      Graphics.moveto (x - 10) y;
      fill_circle (x - 10) y 3
  | 's' ->
      Graphics.moveto x (y - 10);
      fill_circle x (y - 10) 3
  | 'd' ->
      Graphics.moveto (x + 10) y;
      fill_circle (x - 10) y 3
  | _ -> ()

let init (input : unit) =
  Graphics.open_graph " 750x750+500+500";
  Graphics.set_window_title "hai :3";
  Graphics.draw_rect 375 375 25 25;
  Graphics.auto_synchronize true;
  Graphics.display_mode true;
  Graphics.loop_at_exit [ Key_pressed ] move
