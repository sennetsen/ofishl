open Raylib
open Boat
open Fish

(* Documentation of the library can be found here:
   https://tjammer.github.io/raylib-ocaml/raylib/Raylib/index.html *)

let current_fish = ref (Fish.spawn ())

let setup () =
  Raylib.init_window 800 450 "raylib [core] example - basic window";
  Raylib.set_target_fps 60

let rec loop () =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    (* Responding to key presses. *)
    if is_key_down Key.A then Boat.move (Vector2.create ~-.2. 0.) else ();
    if is_key_down Key.D then Boat.move (Vector2.create 2. 0.) else ();
    if is_key_down Key.W then Boat.move (Vector2.create 0. ~-.2.) else ();
    if is_key_down Key.S then Boat.move (Vector2.create 0. 2.) else ();
    if is_key_pressed Key.F && Fish.colliding !Boat.boat_pos !current_fish then
      current_fish := Fish.spawn ()
    else ();
    begin_drawing ();
    clear_background Color.raywhite;
    Boat.draw ();
    Fish.draw !current_fish;
    end_drawing ();
    loop ()

let run () = setup () |> loop
