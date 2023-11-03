open Raylib

(* Documentation of the library can be found here:
   https://tjammer.github.io/raylib-ocaml/raylib/Raylib/index.html *)

let setup () =
  Raylib.init_window 800 450 "raylib [core] example - basic window";
  Raylib.set_target_fps 60

(** The vector value for the current position of the center of the boat in the
    window. *)
let boat_pos = ref (Raylib.Vector2.create 400. 225.)

(** This vector represents the orientation of the boat with respect to an
    ellipsis. boat_h specifically represents the boat's orientation when it is
    moving left and right. The x value corresponds with the horizontal radius
    and the y value corresponds with the vertical radius. *)
let boat_h = Raylib.Vector2.create 15. 10.

(** Using the same format at boat_h, boat_v represents the boat's orientation
    when it moves up and down.*)
let boat_v = Raylib.Vector2.create 10. 15.

(** The reference to the boat's current orientation. Set to boat_h by default. *)
let boat_face = ref boat_h

let rec loop () =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    (* Responding to key presses. *)
    if is_key_down Key.A then (
      boat_face := boat_h;
      boat_pos := Vector2.add !boat_pos (Vector2.create ~-.2. 0.))
    else ();
    if is_key_down Key.D then (
      boat_face := boat_h;
      boat_pos := Vector2.add !boat_pos (Vector2.create 2. 0.))
    else ();
    if is_key_down Key.W then (
      boat_face := boat_v;
      boat_pos := Vector2.add !boat_pos (Vector2.create 0. ~-.2.))
    else ();
    if is_key_down Key.S then (
      boat_face := boat_v;
      boat_pos := Vector2.add !boat_pos (Vector2.create 0. 2.))
    else ();
    (* The x and y coordinates of the center of the boat for easy reference. *)
    let boatx = int_of_float (Vector2.x !boat_pos) in
    let boaty = int_of_float (Vector2.y !boat_pos) in
    (* The horiztonal and vertical radii respectively of the ellipsis that
       represents the boat. *)
    let boatfx = Vector2.x !boat_face in
    let boatfy = Vector2.y !boat_face in
    begin_drawing ();
    clear_background Color.raywhite;
    (* Draws the boat and colors it brown. *)
    draw_ellipse boatx boaty boatfx boatfy Color.brown;
    end_drawing ();
    loop ()

let () = setup () |> loop
